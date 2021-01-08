# enter this URL to reach PowerShell’s web server
$url = 'http://localhost:8080/'

$root = ".."

# HTML content for some URLs entered by the user
$htmlcontents = @{
  'GET /'              = Get-Content $root\www\home.html
  'GET /images/sm.jpg' = Get-Content $root\www\images\sm.jpg
  'GET /services'      = Get-Service | ConvertTo-Html
}

# start web server
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

try
{
  while ($listener.IsListening) {  
    # process received request
    $context = $listener.GetContext()
    $Request = $context.Request
    $Response = $context.Response
    $received = '{0} {1}' -f $Request.httpmethod, $Request.url.localpath
    
    $html = $htmlcontents[$received]
    if ($html -eq $null) {
      $Response.statuscode = 404
      $html = 'Oops, the page is not available!'
    } 
    
    # return the HTML to the caller
    $buffer = [Text.Encoding]::UTF8.GetBytes($html)
    $Response.ContentLength64 = $buffer.length
    $Response.OutputStream.Write($buffer, 0, $buffer.length)


    # console info
    Write-Host $context.Request.RemoteEndPoint "|" $context.Request.HttpMethod $context.Request.RawUrl -ForegroundColor Yellow
    
    $Response.Close()
  }
}
finally
{
  $listener.Stop()
}