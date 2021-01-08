$programs = "McAfee Agent","McAfee DLP Endpoint","McAfee Host Intrusion Prevention","McAfee Policy Auditor Agent","McAfee VirusScan Enterprise"
$Array = @()
ForEach ($Program in $programs){
    If((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Where-Object { $_.GetValue("DisplayName") -like "*$program*" } ).Length -gt 0){
        $Array += $Program + " 64"
    }

    If((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Where-Object { $_.GetValue("DisplayName") -like "*$program*" } ).Length -gt 0){
        $Array += $Program + " 32"
    }
}
$Results.HBSSInstalled = $Array
