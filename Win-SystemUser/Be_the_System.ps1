cd C:\
mkdir temp
cd C:\temp\
wget http://download.sysinternals.com/files/PSTools.zip -OutFile PSTools.zip

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\PSTools.zip", "C:\temp\")

Remove-Item -Path C:\temp\*.exe -Exclude "PsExec.exe", "PsExec64.exe"
Remove-Item -Path C:\temp\*.chm
Remove-Item -Path C:\temp\psversion.txt

Start-Process .\PsExec.exe -ArgumentList "-i -s -d cmd.exe /accepteula"