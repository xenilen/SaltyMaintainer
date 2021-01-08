
If ( Get-Module ActiveDirectory ) {
    Get-ADComputer -filter { operatingSystem -like "Windows Server*" }
}
Else {
    $Searcher = [adsisearcher]'(&(objectclass=computer)(operatingSystem=Windows Server*))'
    $Searcher.SearchRoot = "LDAP://DC=AREA52,DC=AFNOAPPS,DC=USAF,DC=MIL"
    $Searcher.PageSize = 100
    $search = $searcher.FindAll()
    $addcs = $search.properties.name
    $addcs
}