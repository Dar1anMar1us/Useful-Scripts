$udpClient = New-Object System.Net.Sockets.UdpClient
$ip = [System.Net.IPAddress]::Parse("192.168.1.5")  # Replace with your Linux IP
$filePath = "C:\path\to\your\file.txt"
$maxPacketSize = 8192  # Adjust the packet size as needed (e.g., 8192 bytes)

# Read the entire file
$data = [System.IO.File]::ReadAllBytes($filePath)
$fileLength = $data.Length

# Split data into chunks and send
for ($offset = 0; $offset -lt $fileLength; $offset += $maxPacketSize) {
    # Determine the size of the chunk to send
    $chunkSize = [math]::Min($maxPacketSize, $fileLength - $offset)
    $chunk = $data[$offset..($offset + $chunkSize - 1)]
    
    # Send the chunk
    $udpClient.Send($chunk, $chunk.Length, $ip, 69)  # Using TFTP port
    Write-Host "Sent chunk of size $chunkSize bytes"
}

$udpClient.Close()
Write-Host "File sent successfully."

# On linux machine just netcat the input to a file
# nc -u -l -p 69 > received_file
