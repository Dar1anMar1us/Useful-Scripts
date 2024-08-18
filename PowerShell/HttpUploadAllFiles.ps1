$folderPath = "C:\path\to\PSTools"

Get-ChildItem -Path $folderPath -File | ForEach-Object {
    $fileName = $_.Name
    $filePath = Join-Path -Path $folderPath -ChildPath $fileName
    Invoke-RestMethod -Method POST -Uri "http://192.168.45.199/PSTools/$fileName" -InFile $filePath -UseDefaultCredentials
}
