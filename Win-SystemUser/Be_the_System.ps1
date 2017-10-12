    ###    Simon Fieber IT-Services    ###
    ###     Coded by: Simon Fieber     ###
    ###     Visit:  simonfieber.it     ###

cls

### Startbildschirm ###
function startbildschirm {
    Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗"
    Write-Host "║ Be the system user for Windows v0.1.5                                         ║"
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
function Get-PsExec {
    cls
    startbildschirm
        Write-Host "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║ PsExec wird bei Windows Sysinternals heruntergeladen...                       ║"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try{Invoke-WebRequest -Uri https://download.sysinternals.com/files/PSTools.zip -OutFile "C:\temp\PSTools.zip"}
        catch{
            Start-Sleep -Milliseconds 1500
            Write-Host "        ╔═══════════════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ PsExec konnte nicht heruntergeladen werden.                                   ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ║     Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut! ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ║     Sollten Sie kein Problem feststellen können, prüfen Sie bitte auf GitHub, ║"
            Write-Host "        ║     ob dieses Script ein Update erhalten hat.                                 ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ╚═══════════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

### PsExec entpacken ###
function Unzip-PsExec {
    cls
    startbildschirm
        Write-Host "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║ PsExec wird entpackt...                                                       ║"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\PSTools.zip", "C:\temp\")
        } catch {
            Start-Sleep -Milliseconds 1500
            Remove-Item -Path C:\temp\PSTools.zip
            Write-Host "        ╔═══════════════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ PsExec konnte nicht entpackt werden.                                          ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ║     Bitte starten Sie dieses Script als Administrator erneut!                 ║"
            Write-Host "        ║                                                                               ║"
            Write-Host "        ╚═══════════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
        Start-Sleep -Milliseconds 1000
        Remove-Item -Path C:\temp\Ps*.exe -Exclude "PsExec64.exe"
        Remove-Item -Path C:\temp\Pstools.chm
        Remove-Item -Path C:\temp\PSTools.zip
        Remove-Item -Path C:\temp\psversion.txt
}

### Systemrechte abrufen ###
Start-Process .\PsExec.exe -ArgumentList "-i -s -d cmd.exe /accepteula"