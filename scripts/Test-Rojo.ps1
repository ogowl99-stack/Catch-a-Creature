param(
    [string]$RojoPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$projectPath = Join-Path $repositoryRoot "default.project.json"
$trackedSourcemapPath = Join-Path $repositoryRoot "sourcemap.json"
$temporaryRoot = [System.IO.Path]::GetTempPath()
$temporaryId = [guid]::NewGuid().ToString("N")
$temporarySourcemapPath = Join-Path $temporaryRoot "CatchACreature-$temporaryId-sourcemap.json"
$temporaryBuildPath = Join-Path $temporaryRoot "CatchACreature-$temporaryId.rbxlx"

if ([string]::IsNullOrWhiteSpace($RojoPath)) {
    $localRojoPath = Join-Path $repositoryRoot ".tools\rojo\rojo.exe"
    if (Test-Path -LiteralPath $localRojoPath) {
        $RojoPath = $localRojoPath
    } else {
        $rojoCommand = Get-Command rojo -ErrorAction SilentlyContinue
        if ($null -eq $rojoCommand) {
            throw "Rojo was not found. Run 'rokit install' or pass -RojoPath."
        }
        $RojoPath = $rojoCommand.Source
    }
}

try {
    $version = (& $RojoPath --version | Out-String).Trim()
    if ($version -ne "Rojo 7.7.0") {
        throw "Expected Rojo 7.7.0, received '$version'."
    }

    $project = Get-Content -Raw -LiteralPath $projectPath | ConvertFrom-Json
    if ($project.servePlaceIds.Count -ne 1 -or $project.servePlaceIds[0] -ne 72745225515549) {
        throw "servePlaceIds must contain only the authorized Catch A Creature place ID."
    }
    if ($project.tree.PSObject.Properties.Name -contains "Workspace") {
        throw "Workspace must remain outside Rojo authority."
    }

    & $RojoPath sourcemap $projectPath --output $temporarySourcemapPath
    $expectedSourcemap = Get-Content -Raw -LiteralPath $trackedSourcemapPath
    $actualSourcemap = Get-Content -Raw -LiteralPath $temporarySourcemapPath
    if ($expectedSourcemap -cne $actualSourcemap) {
        throw "sourcemap.json is stale. Regenerate it from default.project.json."
    }

    & $RojoPath build $projectPath --output $temporaryBuildPath
    $build = Get-Item -LiteralPath $temporaryBuildPath
    if ($build.Length -le 0) {
        throw "Rojo produced an empty build artifact."
    }

    [pscustomobject]@{
        Result = "PASS"
        RojoVersion = $version
        AuthorizedPlaceId = $project.servePlaceIds[0]
        WorkspaceMapped = $false
        SourcemapFresh = $true
        BuildBytes = $build.Length
    }
} finally {
    foreach ($temporaryPath in @($temporarySourcemapPath, $temporaryBuildPath)) {
        if (Test-Path -LiteralPath $temporaryPath) {
            $resolvedPath = (Resolve-Path -LiteralPath $temporaryPath).Path
            if (-not $resolvedPath.StartsWith($temporaryRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "Refusing to remove an artifact outside the temporary directory: $resolvedPath"
            }
            Remove-Item -LiteralPath $resolvedPath
        }
    }
}
