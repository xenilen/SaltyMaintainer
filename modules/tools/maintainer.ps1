Param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('ad_health','dc','dhcp','general','netiq_dra')]
    $Modules,
    [Parameter(Mandatory=$true)]$Servers
)