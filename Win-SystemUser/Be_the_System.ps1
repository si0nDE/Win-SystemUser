    ###    Simon Fieber IT-Services    ###
    ###     Coded by: Simon Fieber     ###
    ###     Visit:  simonfieber.it     ###

cls

### Startbildschirm ###
function startbildschirm {
    Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗"
    Write-Host "║ Be the system user for Windows v0.1.1                                         ║"
    Write-Host "║                                                                               ║"
    Write-Host "║                                                     (c) github.simonfieber.it ║"
    Write-Host "╚═══════════════════════════════════════════════════════════════════════════════╝"
}

### Erstelle temporäres Verzeichnis ###
cd C:\
mkdir temp
cd C:\temp\

### Download der aktuellsten PsExec-Version ###
wget http://download.sysinternals.com/files/PSTools.zip -OutFile PSTools.zip

### PsExec entpacken ###
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\PSTools.zip", "C:\temp\")

Remove-Item -Path C:\temp\*.exe -Exclude "PsExec.exe", "PsExec64.exe"
Remove-Item -Path C:\temp\*.chm
Remove-Item -Path C:\temp\psversion.txt

### Systemrechte abrufen ###
Start-Process .\PsExec.exe -ArgumentList "-i -s -d cmd.exe /accepteula"