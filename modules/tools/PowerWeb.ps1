# Headless Powershell Webserver
# Start-Job -name WebServer -FilePath .\modules\tools\PowerWeb.ps1 -ArgumentList "$($PWD.Path + "\www")",$Port
# Not RFC 1945/7231 compliant

$RootPath = $args[0]
$Port     = $args[1]

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

# New-PSDrive -Name PowerWeb -PSProvider FileSystem -Root $($PWD.Path + "\www")
New-PSDrive -Name PowerWeb -PSProvider FileSystem -Root $RootPath | Out-Null

While ( $true ) {

    $Context = $listener.GetContext()

    If ( $Context.Request.Url.LocalPath -eq "/" ) {

        $Path = Get-Content -Path PowerWeb:index.html
        $buffer = [Text.Encoding]::UTF8.GetBytes($Path)
        $Context.Response.ContentLength64 = $buffer.length
        $Context.Response.OutputStream.Write($buffer, 0, $buffer.length)
        $Context.Response.Close()

    }

    Else {

        $URL = $Context.Request.Url.LocalPath
        $Content = Get-Content -Encoding Byte -Path "PowerWeb:$URL"
        $Context.Response.OutputStream.Write($Content, 0, $Content.Length)
        $Context.Response.Close()

    }

    $Context.Request.HttpMethod + " " + $Context.Request.Url.LocalPath
    
    <#    
    Switch ( $Context.Request.HttpMethod ) {
        GET     { $1 + " -> " + $2 }
        HEAD    { $1 + " -> " + $2 }
        POST    { $2 + " -> " + $1 }
        PUT     { $2 + " -> " + $1 }
        DELETE  { $2 + " -> " + $1 }
        CONNECT { $2 + " -> " + $1 }
        OPTIONS { $2 + " -> " + $1 }
        TRACE   { $1 + " -> " + $2 }
        PATCH   { $2 + " -> " + $1 }
    } 
    #>

}