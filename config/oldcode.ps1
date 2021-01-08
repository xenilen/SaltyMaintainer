$Checks = @{}
ForEach($Site in $GeoCodes){
    $b = @{
        $Site = @{
            RA = @{
                Servers = $Servers | Select-String "$Site-RA-"
                Script = $([ScriptBlock]::Create($GeneralScript.ToString() + "`n" + $RAScript.ToString()))
                Results = $null
                Problems = $null
            }
            DC = @{
                Servers = $Servers | Select-String "$Site-DC-"
                Script = $([ScriptBlock]::Create($GeneralScript.ToString() + "`n" + $DCScript.ToString()))
                Results = $null
                Problems = $null
            }
            HC = @{
                Servers = $Servers | Select-String "$Site-HC-"
                Script = $([ScriptBlock]::Create($GeneralScript.ToString() + "`n" + $HCScript.ToString()))
                Results = $null
                Problems = $null
            }
        }
    }
    $Checks += $b
}

$i = 0

Write-Host "`nKilling Current Jobs..." -ForegroundColor Cyan
Get-Job | Remove-Job -Force

Write-Host "`nStarting Jobs..." -ForegroundColor Cyan
ForEach ($Site in $Checks.keys) {
    ForEach ($ServerType in $Checks[$Site].Keys) {
        $Computers = $Checks[$Site].$($ServerType).Servers
        $Script = $Checks[$Site].$($ServerType).Script
        ForEach ($Computer in $Computers) {
            While ($(Get-Job -state running).count -ge $MaxThreads){
                Write-Progress  -Activity "Getting service status" -Status "Waiting for threads to close" -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $Servers.count * 100)
                Start-Sleep -Milliseconds $SleepTimer
            }
            $i++
            Invoke-Command -ComputerName $Computer -ScriptBlock $Script -AsJob | Out-Null
            Write-Progress  -Activity "Getting service status" -Status "Starting Threads" -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $Servers.count * 100)
        }
    }
}

Get-Job | Wait-Job
$Results = Get-Job | Receive-job 

$Array = @()
ForEach($Result in $Results){
    $server = $Result.machinename
    Try{
        $ServerPatchingGroup = (((Get-ADComputer -LDAPFilter:"(anr=$server)" -Properties memberof).memberof).split(",") | where {$_ -match "CN=GLS_SCCM_SERVER_Patching"}).trim("CN=")
    }catch{
        $result.patchgroup = "Can't find patching group"
    }

    If($ServerPatchingGroup){
        $result.patchgroup = $ServerPatchingGroup
    }
    $Array += $Result
}
$Results = $Array | Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID,PSShowComputerName
$JSONResults = $Results | ConvertTo-Json -Depth 100


If(!(Test-Path .\Logs\$Date)){
    New-Item -Path .\Logs -Name $Date -ItemType Directory | Out-Null
}

$JSONResults | Out-File .\Logs\$Date\Results.json
$RAResults = $Results | Where {$_.MachineName -like "*-ra-*"}
$DCResults = $Results | Where {$_.MachineName -like "*-dc-*"}
$HCResults = $Results | Where {$_.MachineName -like "*-hc-*"}



$RAResults | Export-Csv ".\Logs\$Date\RA.csv" -NoTypeInformation
$DCResults | Export-Csv ".\Logs\$Date\DC.csv" -NoTypeInformation
$HCResults | Export-Csv ".\Logs\$Date\HC.csv" -NoTypeInformation
