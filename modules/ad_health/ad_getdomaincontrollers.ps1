<#
forest_name {
    forest_dc1
    forest_dc2
    domain_name1{
        domain_dc
    }
    domain_name2{
        domain_dc
    }
}
#>

If ( Get-Module ActiveDirectory ) {
    # $adforest = Get-ADForest
    $addcs = Get-ADDomainController -filter *

    # $forestglobalcatalogs = $ADForest.globalcatalogs
    # $domaincontrollersinOU = $ADDCs.hostname
    # $dcsthatarentgcs = $domaincontrollersinOU | ? { $forestglobalcatalogs -notcontains $_ }
    
    $addcs.name

}
Else {
    $Searcher = [adsisearcher]"objectclass=computer"
    $Searcher.SearchRoot = "LDAP://OU=Domain Controllers,DC=AREA52,DC=AFNOAPPS,DC=USAF,DC=MIL"
    $search = $searcher.FindAll()
    $addcs = $search.properties.name
    $addcs
}