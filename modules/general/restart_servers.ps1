ForEach ($Site in $GeoCodes){
    $Computers = $ServerList | Select-String "$Site"
    $S = {
        $Computers = $args
        $Array = @()
        $1 = $Computers | Select-String "001"
        $2 = $Computers | Select-String "002"
        $3 = $Computers | Select-String "003"

        Restart-Computer -ComputerName $1 -Wait -For WinRM -Force -Timeout 900
        $1 | ForEach {
            $Result = "" | Select Good,Bad
            If(test-path \\$_\c$){
                $Result.Good = $_
            }Else{
                $Result.Bad = $_
            }
            $Array += $Result
        }

        Restart-Computer -ComputerName $2 -Wait -For WinRM -Force -Timeout 900
        $2 | ForEach {
            $Result = "" | Select Good,Bad
            If(test-path \\$_\c$){
                $Result.Good = $_
            }Else{
                $Result.Bad = $_
            }
            $Array += $Result
        }

        Restart-Computer -ComputerName $3 -Wait -For WinRM -Force -Timeout 900
        $3 | ForEach {
            $Result = "" | Select Good,Bad
            If(test-path \\$_\c$){
                $Result.Good = $_
            }Else{
                $Result.Bad = $_
            }
            $Array += $Result
        }
    
        $Array
    }

    Start-Job  -ArgumentList $Computers -ScriptBlock $S | Out-Null
}