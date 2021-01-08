# Fail if DiskPctLeft <= 15
# Warning if <= 20
$Disks = Get-PSDrive | Where free -GE 0 | select name,used,free
$Array=@()
$BadDisks = 0
ForEach($Disk in $Disks){
    $DiskName = $Disk.name
    $DiskUsed = [math]::round($Disk.Used /1Gb)
    $DiskFree = [math]::round($Disk.Free /1Gb)
    $DiskTotal = [math]::round(($Disk.used + $Disk.free)/1Gb)
    $DiskPctFree = [math]::Round(($Disk.free /($Disk.used + $Disk.free))*100)
    $DiskPctUsed = [math]::round(100 - $DiskPctFree)
    If($DiskPctUsed -ge 85){
        $BadDisks++
    }
    $Array += "Drive:" + "$DiskName" + " Fract: " + "$DiskUsed" + "GB" + "/" + "$DiskTotal" + "GB" + " PctUsed: " + "$DiskPctUsed" + "%"
}
If ($BadDisks -gt 0) {
    $Results.DriveSpace = "FAILED: $BadDisks`n" + (@($Array) | Out-String).Trim()

}
Else {
    $Results.DriveSpace = "Pass`n" + (@($Array) | Out-String).Trim()
}