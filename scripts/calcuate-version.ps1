$ErrorActionPreference = "Stop"
Set-PSDebug -Strict
Import-Module -Name $(Join-Path $PSScriptRoot "modules" "buildkite.psm1")
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

if ($env:BUILDKITE) {
    Write-Host "`n--- Setting Buildkite Metadata"
    $calulatedVersions.GetEnumerator() | ForEach-Object {
        Set-BuildkiteMetadata -Name $_.Key -Value $_.Value
    }
    $annotation = "Building Version: <span class='bold'>$($calulatedVersions.version)</span>"
    buildkite-agent annotate $annotation --style "info" --context "version-info"
}
