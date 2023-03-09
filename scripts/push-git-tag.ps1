$ErrorActionPreference = "Stop"
Set-PSDebug -Strict
Import-Module -Name $(Join-Path $PSScriptRoot "modules" "version.psm1")

Write-Output "`n--- Create Git Tag if on Main or Hotfix branch ---"

if (!$env:BUILDKITE) {
    Write-Output "`n Create tag in Buildkite only"
    Exit 1
}
$branchName = $env:BUILDKITE_BRANCH
if ((Get-IsMainBranch -BranchName $branchName) -or (Get-IsHotfixBranch -BranchName $branchName )) {
    
    Write-Output "`n--- Get Current Version and Create Git Tag"
    $currentVersion = Get-Version

    $message = "Buildkite build: $env:BUILDKITE_BUILD_URL"
    Write-Output "`n--- Current Version to create git tag --> $currentVersion"

    git tag "v${currentVersion}" -m "${message}"
    git push --tags
}
