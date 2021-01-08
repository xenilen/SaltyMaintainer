# DHCP Scope test
# NEED TO TEST WITH Out-Null

try{
    Get-DhcpServerv4Scope -ErrorAction Stop | Out-Null
    $Results.DHCPScopes = "Success"
}

catch{
    $Results.DHCPScopes = "Failed"
}
