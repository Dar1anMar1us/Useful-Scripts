$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:80/")
$listener.Start()
Write-Host "HTTP server started. Press Ctrl+C to stop."

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
  
    if ($request.HttpMethod -eq "POST") {
        $length = $request.ContentLength64
        $data = New-Object byte[] $length
        $stream = $request.InputStream
        $stream.Read($data, 0, $length) | Out-Null
        $stream.Close()

        $filePath = Join-Path -Path $PWD -ChildPath $request.Url.LocalPath.Substring(1)
        [System.IO.File]::WriteAllBytes($filePath, $data)

        $response.StatusCode = 200
        $response.OutputStream.Close()
    }
    else {
        $response.StatusCode = 404
        $response.OutputStream.Close()
    }
    
}

$listener.Stop()
