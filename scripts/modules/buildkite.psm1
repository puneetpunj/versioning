function Set-BuildkiteMetadata {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    if ($env:BUILDKITE) {
        Write-Host "Setting $($Name)=$($Value)"
        $response = buildkite-agent meta-data set $Name $Value
        $returnCode = $LASTEXITCODE
        if ($returnCode -ne 0) {
            Write-Error "Failed to set Buildkite meta-data for '$($Name)=$($Value)' with return code $($returnCode) and reponse '$($response)'"
        }
    }
}
function Get-BuildkiteMetadata {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($env:BUILDKITE) {
        return buildkite-agent meta-data get $Name
    }
    else {
        return $null
    }
}