    ###    Simon Fieber IT-Services    ###
    ###     Coded by: Simon Fieber     ###
    ###     Visit:  simonfieber.it     ###

cls
### Fehlermeldungen unterdrücken ###
### Mögliche Fehlermeldungen: Dateien oder Ordner können nicht gelöscht werden, da diese nicht existieren. ###
$ErrorActionPreference = "SilentlyContinue"

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
$gci_installpath = Get-ChildItem $installpath
$systemtype = Get-WmiObject -Class Win32_ComputerSystem -ComputerName . | Select-Object -Property SystemType

### Erstelle Installationsverzeichnis ###
function Create-InstallDirectory {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ Installationsverzeichnis wird erstellt...                                 ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        if(Test-Path -Path "$installpath\PsExec"){}
        else {
            try {mkdir $installpath\PsExec | Out-Null}
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
        try{Invoke-WebRequest -Uri https://download.sysinternals.com/files/PSTools.zip -OutFile "$installpath\PsExec\PSTools.zip"}
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
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$installpath\PsExec\PSTools.zip", "$installpath\PsExec")
        } catch {
            Start-Sleep -Milliseconds 1500
            Remove-Item -Path $installpath\PsExec\PSTools.zip
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
        if($systemtype -match "x64*") {
            Remove-Item -Path $installpath\PsExec\Ps*.exe -Exclude "PsExec64.exe"
        } else {
            Remove-Item -Path $installpath\PsExec\Ps*.exe -Exclude "PsExec.exe"
        }
        Remove-Item -Path $installpath\PsExec\Pstools.chm
        Remove-Item -Path $installpath\PsExec\PSTools.zip
        Remove-Item -Path $installpath\PsExec\psversion.txt
}

### Menü: Systemrechte abrufen ###
function Get-SystemUser {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ Welches Programm möchten Sie mit Systemrechten starten?                   ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ║ [ 1 ] Command Prompt (cmd.exe)     ║ [ 2 ] PowerShell (powershell.exe)    ║"
        Write-Host "   ║                                    ║                                      ║"
        Write-Host "   ╚════════════════════════════════════╩══════════════════════════════════════╝"
        Write-Host ""
        $input = Read-Host "Bitte wählen Sie"

        switch ($input) {
            '1' {Get-CMD-SystemUser}
            '2' {Get-PS-SystemUser}
        }
}

### Systemrechte mit CMD abrufen ###
function Get-CMD-SystemUser {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ Eingabeaufforderung wird als Systembenutzer gestartet...                  ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 1500
        $error.Clear()
        try {
            if($systemtype -match "x64*") {
                Start-Process $installpath\PsExec\PsExec64.exe -ArgumentList "-i -s -d cmd.exe /accepteula"
            } else {
                Start-Process $installpath\PsExec\PsExec.exe -ArgumentList "-i -s -d cmd.exe /accepteula"
            }
        }
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

### Systemrechte mit PS abrufen ###
function Get-PS-SystemUser {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ PowerShell wird als Systembenutzer gestartet...                           ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        Start-Sleep -Milliseconds 1500
        $error.Clear()
        try {
            if($systemtype -match "x64*") {
                Start-Process $installpath\PsExec\PsExec64.exe -ArgumentList "-i -s -d powershell.exe /accepteula"
            } else {
                Start-Process $installpath\PsExec\PsExec.exe -ArgumentList "-i -s -d powershell.exe /accepteula"
            }
        } catch {
            Start-Sleep -Milliseconds 1500
            Write-Host "        ╔══════════════════════════════════════════════════════════════════════╗"
            Write-Host "        ║ Ein unbekannter Fehler ist aufgetreten!                              ║"
            Write-Host "        ║                                                                      ║"
            Write-Host "        ╚══════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3500
            Error-Exit
        }
}

### Starte Script und suche PsExec ###
function Start-PsExec {
    cls
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ PsExec wird gesucht...                                                    ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        $error.Clear()
        Start-Sleep -Milliseconds 500
        if($gci_installpath -match "PsExec*"){Get-SystemUser}
        else{
            Create-InstallDirectory
            Start-Sleep -Milliseconds 1500
            Get-PsExec
            Start-Sleep -Milliseconds  500
            Unzip-PsExec
            Start-Sleep -Milliseconds 1500
            Get-SystemUser
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
    Start-PsExec
}
