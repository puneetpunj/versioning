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
