<#
$action = New-ScheduledTaskAction -Execute 'Powershell.exe'
$trigger =  New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "SaltyMaintainer" -Description "Daily run of tasks"
Unregister-ScheduledTask -TaskName "SaltyMaintainer"
#>

