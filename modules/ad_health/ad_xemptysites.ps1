<#
Modified code from
https://practicalpowershell.com/ad-sites-and-services-powershell/
#>

# Empty Site Check
Param($ScriptFile = {
    [System.Threading.Thread]::CurrentThread.Priority = 'Lowest'
    $Site = $args[0]
    If ( (Get-ADDomainController -Filter {Site -eq $Site}).Count -eq 0 ) { 
        $Site  
    } 
}, 
    $MaxThreads = 10,
    $SleepTimer = 500,
    $MaxWaitAtEnd = 600,
    $OutputType = "Text")


$computers = (Get-ADReplicationSite -Filter *).Name 
 
$i = 0
ForEach ($computer in $computers){
    While ($(Get-Job -state running).count -ge $MaxThreads){
        Write-Progress  -Activity "Spawning threads" -Status "Waiting for threads to close" -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $computers.count * 100)
        Start-Sleep -Milliseconds $SleepTimer
    }
    $i++
    Start-Job -ScriptBlock $ScriptFile -ArgumentList $computer | Out-Null
    Write-Progress  -Activity "Spawning threads" -Status "Starting Threads" -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $computers.count * 100)
    
}
 
Write-Host "Waiting for jobs to complete, this may take a few minutes" -ForegroundColor Cyan
$yeet = Get-Job | Wait-Job | Receive-Job
$yeet