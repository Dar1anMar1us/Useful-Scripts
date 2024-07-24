$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:80/")
$listener.Start()
Write-Host "HTTP server started. Press Ctrl+C to stop."

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $requestUrl = $context.Request.Url
    $localPath = $requestUrl.LocalPath.Substring(1)
    
    if ($localPath) {
        $data = [System.IO.File]::ReadAllBytes($localPath)
        $buffer = [System.Byte[]]$data
        $response = $context.Response
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
}

$listener.Stop()
