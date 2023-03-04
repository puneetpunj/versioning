$ErrorActionPreference = "Stop"
Set-PSDebug -Strict
Import-Module -Name $(Join-Path $PSScriptRoot "modules" "version.psm1")

Write-Host "`n--- Running GitVersion`n"

$gitVersionMetadata = Get-GitVersionMetaData
if (!$gitVersionMetadata) {
    Exit 1
}

Write-Host "`nGitVersion successful."
Write-Host "`n--- GitVersion Metadata"
Write-Output $gitVersionMetadata

Write-Host "`n--- Calculated Versions"
$calulatedVersions = Get-CalculatedVersions $gitVersionMetadata
Write-Output $calulatedVersions | ConvertTo-Json | ConvertFrom-Json

# create git tag only in CI pipeline
if ($env:CI){
    $message = "Build: $env:BUILD_URL"
    git tag "v${$calulatedVersions["Version"]}" -m "${message}"
    git push --tags
}