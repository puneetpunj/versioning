Import-Module -Name $(Join-Path $PSScriptRoot "git.psm1")

function Get-Version {
    return Get-VersionCore "Version"
}

function Get-VersionCore {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    $metaData = Get-GitVersionMetaData
    if (!$metaData) {
        return $null
    }
    
    return (Get-CalculatedVersions $metaData).$Key
}

function Get-CalculatedVersions {
    param (        
        [Parameter(Mandatory = $true)]
        [object] $GitVersionMetaData
    )
    
    $branchName = $gitVersionMetadata.BranchName
    $version = $GitVersionMetaData.MajorMinorPatch
    $build_number = 1

    if ( !(Get-IsMainBranch -BranchName $branchName) -and !(Get-IsHotfixBranch -BranchName $branchName)) {
        $escapedBranchName = $branchName -replace "[^a-zA-Z0-9-]", "-"
        $version = "$($version).ci-$build_number-$escapedBranchName.$($GitVersionMetaData.ShortSha)"
    }
    
    return @{
        Version = $version
    }
}

function Get-GitVersionMetaData {
    param (
        # gitversion docker image tag
        [String] $GitVersionImageTag = "5.10.3"
    )

    $repoPath = (Get-Item $PSScriptRoot).Parent.Parent
    # calculate-version.env file is created under the tmp folder.
    $tmpPath = $(Join-Path $repoPath "tmp")
    $envFile = $(Join-Path $tmpPath ".env")

    try {
        
        Write-Host "docker run --rm -v "$($repoPath):/repo" gittools/gitversion:$GitVersionImageTag /repo"
                
        $responseJson = $(docker run --rm -v "$($repoPath):/repo" gittools/gitversion:$GitVersionImageTag /repo)
        
        $returnCode = $LASTEXITCODE
        if ($returnCode -ne 0) {
            Write-Host "`nGitVersion failed - docker returned non-zero return code of $returnCode."
            if ($responseJson) {
                Write-Error "`nGitVersion response '$responseJson'"
            }
            return $null
        }
    
        return ($responseJson | ConvertFrom-Json)
    }
    catch {
        Write-Error "`n$_.Exception.Message"
        return $null
    }
    finally {
        if (Test-Path -Path $tmpPath) {
            Remove-Item -Path $tmpPath -Force -Recurse
        }
    }
}
