$obj = ""| Select IPConf,Status
$obj.IPConf = Get-NetIPConfiguration

If($obj.IPConf.NetProfile.Name -EQ "AFNOAPPS.USAF.MIL"){
        # Found AFNOAPPS.USAF.MIL NIC
        $obj.Status = "Pass"
    }Else{
        # NO NIC CALLED AFNOAPPS.USAF.MIL
        $obj.Status = "Fail"
}
