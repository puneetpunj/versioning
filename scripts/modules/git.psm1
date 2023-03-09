function Get-IsMainBranch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    return ("master", "main" -contains $BranchName)
}

function Get-IsReleaseBranch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    return ($BranchName -match '^(releases?)[/-]\d+(\.?\d*)*$|^\d+_\d$')
}

function Get-IsHotfixBranch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    return ($BranchName -match '^(hotfix(es)?)[/-]\d+(\.?\d*)*$|^\d+(_\d)*.*_BRANCH$')
}
