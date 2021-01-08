# Web Server Connection
# Uses HTTP Codes to decide pass/fail
# Pass 403 means you are not authorized for logon. That means that the site is up, but we were denied access because no credential
# Warning if Code 2XX.  Shouldn't happen because we don't provide a credential to the site
# Fails if anything else
# https://en.wikipedia.org/wiki/HTTP_code

$FQDN = "$env:COMPUTERNAME.$env:userdnsdomain"
try{
    Invoke-RestMethod -Uri "https://$FQDN/dra"
}catch{
    $HTTPCode = $_.Exception.Response.StatusCode.value__
    $Error = $_.Exception
}
If ($HTTPCode -eq 403){
    "Pass`n" + $HTTPCode
}ElseIf($HTTPCode -ge 200 -and $HTTPCode -le 299){
    "Warning`n" + $HTTPCode
}
Else{
    "Fail`n" + $HTTPCode + $Error
}
