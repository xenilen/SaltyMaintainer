If (Test-Path "C:\Program Files\McAfee\Agent\cmdagent.exe") {
    $Array.AgentConfigs = & "C:\Program Files\McAfee\Agent\cmdagent.exe" -i
} 
Else {
    $Array.AgentConfigs = 'FAILED TO FIND "C:\Program Files\McAfee\Agent\cmdagent.exe"'
}