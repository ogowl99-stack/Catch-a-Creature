--!strict

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local ProfileSchema = require(script.Parent.ProfileSchema)

local PRODUCTION_DATASTORE_NAME = "CatchACreature_Phase3A_v1"
local STUDIO_TEST_DATASTORE_NAME = "CatchACreature_StudioPersistenceTest_20260721_v1"
local STUDIO_TEST_FLAG_NAME = "CatchACreatureStudioPersistenceTestEnabled"
local LEASE_SECONDS = 120
local RELEASE_ATTEMPTS = 3
local RELEASE_RETRY_SECONDS = 0.25

local ProfileRepository = {}
ProfileRepository.__index = ProfileRepository

function ProfileRepository.new()
	local isStudio = RunService:IsStudio()
	local studioTestFlag = ServerStorage:FindFirstChild(STUDIO_TEST_FLAG_NAME)
	local useStudioTestStore = isStudio and studioTestFlag ~= nil and studioTestFlag:IsA("BoolValue") and studioTestFlag.Value
	local useMemory = isStudio and not useStudioTestStore
	local dataStoreName = if useStudioTestStore then STUDIO_TEST_DATASTORE_NAME else PRODUCTION_DATASTORE_NAME
	local self = setmetatable({
		_mode = if useMemory then "Memory (Simulated)" elseif useStudioTestStore then "Studio DataStore Test (Isolated)" else "DataStore (Requires production testing)",
		_store = if useMemory then nil else DataStoreService:GetDataStore(dataStoreName),
		_sessions = {},
		_memoryProfiles = {},
		_instanceId = string.format("%s:%s", if game.JobId ~= "" then game.JobId else "studio", HttpService:GenerateGUID(false)),
	}, ProfileRepository)
	return self
end

ProfileRepository.StudioTestDataStoreName = STUDIO_TEST_DATASTORE_NAME
ProfileRepository.StudioTestFlagName = STUDIO_TEST_FLAG_NAME

function ProfileRepository:getMode(): string
	return self._mode
end

function ProfileRepository:getProfile(player: Player): any?
	local session = self._sessions[player]
	return if session then session.profile else nil
end

function ProfileRepository:isWritable(player: Player): boolean
	local session = self._sessions[player]
	return session ~= nil and session.writable == true
end

function ProfileRepository:load(player: Player): (boolean, string?)
	local nowUnix = os.time()
	local sessionToken = string.format("%s:%d:%s", self._instanceId, player.UserId, HttpService:GenerateGUID(false))
	if self._store == nil then
		local stored = self._memoryProfiles[player.UserId]
		local profile = if stored then ProfileSchema.clone(stored) else ProfileSchema.new(nowUnix)
		profile.meta.activeSessionId = sessionToken
		profile.meta.leaseExpiresAtUnix = nowUnix + LEASE_SECONDS
		self._sessions[player] = {
			profile = profile,
			writable = true,
			token = sessionToken,
		}
		return true, nil
	end

	local blocked = false
	local invalid = false
	local key = "player:" .. player.UserId
	local ok, loaded = pcall(function()
		return self._store:UpdateAsync(key, function(current)
			local candidate = nil
			if current == nil then
				candidate = ProfileSchema.new(nowUnix)
			else
				candidate = ProfileSchema.decodeAndMigrate(current, nowUnix)
			end
			if candidate == nil then
				invalid = true
				return nil
			end
			local meta = candidate.meta
			if meta.activeSessionId ~= nil and meta.activeSessionId ~= sessionToken and (meta.leaseExpiresAtUnix or 0) > nowUnix then
				blocked = true
				return nil
			end
			candidate.meta.activeSessionId = sessionToken
			candidate.meta.leaseExpiresAtUnix = nowUnix + LEASE_SECONDS
			return candidate
		end)
	end)

	if not ok or loaded == nil or blocked or invalid then
		self._sessions[player] = {
			profile = nil,
			writable = false,
		}
		return false, if blocked then "SESSION_BUSY" elseif invalid then "INVALID_PROFILE" else "LOAD_FAILED"
	end

	self._sessions[player] = {
		profile = loaded,
		writable = true,
		token = sessionToken,
	}
	return true, nil
end

function ProfileRepository:commit(player: Player, expectedRevision: number, candidate: any): boolean
	local valid = ProfileSchema.validate(candidate)
	if not valid then
		return false
	end
	local session = self._sessions[player]
	if session == nil or session.writable ~= true or session.profile == nil then
		return false
	end

	if self._store == nil then
		if session.profile.profileRevision ~= expectedRevision then
			session.writable = false
			return false
		end
		candidate.meta.activeSessionId = session.token
		candidate.meta.leaseExpiresAtUnix = os.time() + LEASE_SECONDS
		session.profile = candidate
		self._memoryProfiles[player.UserId] = ProfileSchema.clone(candidate)
		return true
	end

	local accepted = false
	local nowUnix = os.time()
	local key = "player:" .. player.UserId
	local ok, saved = pcall(function()
		return self._store:UpdateAsync(key, function(current)
			if current == nil then
				return nil
			end
			local currentValid = ProfileSchema.validate(current)
			if not currentValid or current.meta.activeSessionId ~= session.token then
				return nil
			end
			if current.profileRevision ~= expectedRevision then
				return nil
			end
			local durable = ProfileSchema.clone(candidate)
			durable.meta.activeSessionId = session.token
			durable.meta.leaseExpiresAtUnix = nowUnix + LEASE_SECONDS
			accepted = true
			return durable
		end)
	end)

	if not ok or saved == nil or not accepted then
		session.writable = false
		return false
	end
	session.profile = saved
	return true
end

function ProfileRepository:refresh(player: Player): boolean
	local session = self._sessions[player]
	if session == nil or session.writable ~= true then
		return false
	end
	local nowUnix = os.time()
	if self._store == nil then
		if session.profile then
			session.profile.meta.leaseExpiresAtUnix = nowUnix + LEASE_SECONDS
			self._memoryProfiles[player.UserId] = ProfileSchema.clone(session.profile)
		end
		return session.profile ~= nil
	end
	local key = "player:" .. player.UserId
	local ok, refreshed = pcall(function()
		return self._store:UpdateAsync(key, function(current)
			if current == nil or current.meta.activeSessionId ~= session.token then
				return nil
			end
			local candidate = ProfileSchema.clone(current)
			candidate.meta.leaseExpiresAtUnix = nowUnix + LEASE_SECONDS
			return candidate
		end)
	end)
	if ok and refreshed ~= nil then
		session.profile = refreshed
		return true
	else
		session.writable = false
		return false
	end
end

function ProfileRepository:release(player: Player)
	local session = self._sessions[player]
	self._sessions[player] = nil
	if session == nil or session.profile == nil then
		return
	end
	if self._store == nil then
		local durable = ProfileSchema.clone(session.profile)
		durable.meta.activeSessionId = nil
		durable.meta.leaseExpiresAtUnix = nil
		self._memoryProfiles[player.UserId] = durable
		return
	end
	local key = "player:" .. player.UserId
	for attempt = 1, RELEASE_ATTEMPTS do
		local matchedSession = false
		local ok = pcall(function()
			self._store:UpdateAsync(key, function(current)
				matchedSession = false
				if current == nil or current.meta.activeSessionId ~= session.token then
					return nil
				end
				matchedSession = true
				local candidate = ProfileSchema.clone(current)
				candidate.meta.activeSessionId = nil
				candidate.meta.leaseExpiresAtUnix = nil
				return candidate
			end)
		end)
		if ok then
			return
		end
		if attempt < RELEASE_ATTEMPTS then
			task.wait(RELEASE_RETRY_SECONDS)
		end
	end
	warn(string.format("[CatchACreature] Failed to release profile lease for user %d after %d attempts", player.UserId, RELEASE_ATTEMPTS))
end

return ProfileRepository
