<#
Salty Maintainer.

[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()  

#>

# Import variables
. .\config\config.ps1

# Launch WebServer
$WebServer = Start-Job -name WebServer -FilePath .\modules\tools\PowerWeb.ps1 -ArgumentList "$($PWD.Path + "\www")",$Port

# Get servers from active directory
# 0 = automatic
# 1 = manual
Switch ( $ServerList ) {
    0 { $ServerOptions = .\modules\tools\Get-Serverlist.ps1 -Options $ServerOptions }
    1 { "Need to figure out what to do here" }
}
