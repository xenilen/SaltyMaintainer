<#
Modified code from
https://practicalpowershell.com/ad-sites-and-services-powershell/
#>

$Sites = (Get-ADReplicationSite -Filter *).Name 

$Array = @()
ForEach ($Site in $Sites) {
    If ( (Get-ADDomainController -Filter {Site -eq $Site}).Count -eq 0 ) { 
        $Array += $Site  
    } 
}
$Array