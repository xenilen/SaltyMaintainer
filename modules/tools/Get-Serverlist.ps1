Param(
    [Parameter(Mandatory=$true)]$Options
)

# Gets servers from AD based on the server identifiers in the config.  Then adds them back to the hashtable.

$ServerTypes = $ServerOptions.Keys
ForEach( $ServerType in $ServerTypes ) {
    If ( $ServerOptions[$ServerType].Enabled -eq $true ) {
        $Computers = Get-ADComputer -filter "Name -like `"$($ServerOptions[$ServerType].ServerIdentifier)`""
        $ServerOptions[$ServerType].Add("Servers",$Computers)
    }
}

$ServerOptions