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
function Create-TempDirectory {
    cls
    startbildschirm
        Write-Host "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║ Temporäres Verzeichnis wird auf Laufwerk C:\ erstellt...                      ║"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try {mkdir C:\temp\ | Out-Null}
        catch{
            Start-Sleep -Milliseconds 1500
            Write-Host "        ╔═══════════════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ Das temporäre Verzeichnis konnte nicht erstellt werden.                       ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ║     Bitte starten Sie dieses Script als Administrator erneut!                 ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ╚═══════════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

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