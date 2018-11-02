    ###    Simon Fieber IT-Services    ###
    ###     Coded by: Simon Fieber     ###
    ###     Visit:  simonfieber.it     ###

cls

### Startbildschirm ###
function startbildschirm {
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗"
    Write-Host "║ Be the system user for Windows                                               ║"
    Write-Host "║                                                                              ║"
    Write-Host "║                                                       (c) www.simonfieber.it ║"
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝"
}

### Root-Verzeichnis ermitteln, zum öffnen des Programmcodes ###
function Get-ScriptDirectory {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

$installpath = Get-ScriptDirectory

### Erstelle temporäres Verzeichnis ###
function Create-TempDirectory {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ Temporäres Verzeichnis wird auf Laufwerk C:\ erstellt...                  ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try {mkdir C:\temp\ | Out-Null}
        catch{
            Start-Sleep -Milliseconds 1500
            Write-Host "      ╔════════════════════════════════════════════════════════════════════════╗"
            Write-Host "      ║ Das temporäre Verzeichnis konnte nicht erstellt werden.                ║"
            Write-Host "      ║                                                                        ║"
            Write-Host "      ║     Bitte starten Sie dieses Script als Administrator erneut!          ║"
            Write-Host "      ║                                                                        ║"
            Write-Host "      ╚════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

### Download der aktuellsten PsExec-Version ###
function Get-PsExec {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ PsExec wird bei Windows Sysinternals heruntergeladen...                   ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try{Invoke-WebRequest -Uri https://download.sysinternals.com/files/PSTools.zip -OutFile "C:\temp\PSTools.zip"}
        catch{
            Start-Sleep -Milliseconds 1500
            Write-Host "        ╔══════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ PsExec konnte nicht heruntergeladen werden.                          ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ║     Bitte überprüfen Sie Ihre Internetverbindung und                 ║"
            Write-Host "        ║     versuchen Sie es erneut!                                         ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ║     Sollten Sie kein Problem feststellen können, prüfen Sie bitte    ║"
            Write-Host "        ║     auf GitHub, ob dieses Script ein Update erhalten hat.            ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ╚══════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

### PsExec entpacken ###
function Unzip-PsExec {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ PsExec wird entpackt...                                                   ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\PSTools.zip", "C:\temp\")
        } catch {
            Start-Sleep -Milliseconds 1500
            Remove-Item -Path C:\temp\PSTools.zip
            Write-Host "        ╔══════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ PsExec konnte nicht entpackt werden.                                 ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ║     Bitte starten Sie dieses Script als Administrator erneut!        ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ╚══════════════════════════════════════════════════════════════════════╝"
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
function Get-SystemUser {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ Eingabeaufforderung wird als Systembenutzer gestartet...                  ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 1500
        $error.Clear()
        try {Start-Process C:\temp\PsExec64.exe -ArgumentList "-i -s -d cmd.exe /accepteula"}
        catch {
            Start-Sleep -Milliseconds 1500
            Write-Host "        ╔══════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ Ein unbekannter Fehler ist aufgetreten!                              ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ╚══════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

function Error-Exit {
        Write-Host "            ╔══════════════════════════════════════════════════════════════════════╗"
        Write-Host "            ║ Programm wird beendet...                                             ║"
        Write-Host "            ║                                                                      ║"
        Write-Host "            ╚══════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 5000
    [Environment]::Exit(1)
}

### Start ###
if($installpath -like "*\GitHub\Win-SystemUser\*") {
    cls
    startbildschirm
        Start-Sleep -Milliseconds 500
        Write-Host "    ╔══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║ Update scheint in der Entwicklungsumgebung ausgeführt zu werden.         ║"
        Write-Host "    ║                                                                          ║"
        Write-Host "    ║     Programm wird beendet...                                             ║"
        Write-Host "    ║                                                                          ║"
        Write-Host "    ╚══════════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 5000
        [Environment]::Exit(1)
} elseif($PSVersionTable.PSVersion -lt "3.0") {
    cls
    startbildschirm
        Start-Sleep -Milliseconds 500
        Write-Host "    ╔══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║ Das Script benötigt zum Download PowerShell-Version 3.0 oder höher.      ║"
        Write-Host "    ║                                                                          ║"
        Write-Host "    ║ Bitte aktualisieren Sie Ihre PowerShell-Umgebung oder laden Sie PsExec   ║"
        Write-Host "    ║ Update manuell bei Windows Sysinternals herunter.                        ║"
        Write-Host "    ║                                                                          ║"
        Write-Host "    ║     Programm wird beendet...                                             ║"
        Write-Host "    ║                                                                          ║"
        Write-Host "    ╚══════════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 5000
        [Environment]::Exit(1)
} else {
    Start-Sleep -Milliseconds  500
    Create-TempDirectory
    Start-Sleep -Milliseconds 1500
    Get-PsExec
    Start-Sleep -Milliseconds  500
    Unzip-PsExec
    Start-Sleep -Milliseconds 1500
    Get-SystemUser
}