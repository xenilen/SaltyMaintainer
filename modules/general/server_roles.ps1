# DISABLED UNTILL WE HAVE LIST OF CORRECT SERVER ROLES
# $Results.features = (@(Get-WindowsFeature | where {$_.installed -eq $true}).displayname | Out-String).Trim()