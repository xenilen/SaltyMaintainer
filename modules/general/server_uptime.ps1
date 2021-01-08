Function Format-Uptime {
    Process{
        "{0:00} Days {1:00} Hours {2:00} Minutes {3:00} Seconds" -f $_.Days,$_.Hours,$_.Minutes,$_.Seconds
    }
}

$Uptime = "" | Select LastBootTime,Uptime
try {
    $WMIObj = Get-WmiObject Win32_OperatingSystem -ErrorAction Stop
    $lastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($WMIObj.LastBootUpTime)
    $Uptime.LastBootTime = $lastBootTime
    $Uptime.Uptime = ((Get-Date) - $lastBootTime) | Format-Uptime
}
catch {
    $Uptime.LastBootTime = ("'$($_.Exception.Message)'",$_.Exception)
    $Uptime.Uptime = ("'$($_.Exception.Message)'",$_.Exception)
    return
}
If (((Get-Date) - $lastBootTime).Days -ge 7){
    "Fail`n" + $Uptime.Uptime
}ElseIf(((Get-Date) - $lastBootTime).Days -eq 6){
    "Warning`n" + $Uptime.Uptime
}Else{
    "Pass`n" + $Uptime.Uptime
}