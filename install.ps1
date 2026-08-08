#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Installs kanata with the mac-win-shortcuts config.

    Downloads the latest kanata release, copies the config, sets up autostart
    via Task Scheduler and starts kanata. By default no kernel driver is
    installed - kanata runs on Windows hooks (winIOv2 variant).

    Safe to re-run: updates kanata and the config in place.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File install.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File install.ps1 -Variant wintercept -NoAutostart
#>
param(
    # winIOv2 = Windows hooks, no driver (default), wintercept = Interception kernel driver (works in games)
    [ValidateSet('winIOv2', 'wintercept')]
    [string]$Variant = 'winIOv2',

    [string]$InstallDir = "$env:LOCALAPPDATA\kanata",

    # Skip creating the logon scheduled task
    [switch]$NoAutostart
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$KanataZipUrl       = 'https://github.com/jtroo/kanata/releases/latest/download/windows-binaries-x64.zip'
$InterceptionZipUrl = 'https://github.com/oblitum/Interception/releases/latest/download/Interception.zip'
$ConfigName         = 'mac-win-shortcuts.kbd'
$TaskName           = 'kanata'
$KanataExe          = Join-Path $InstallDir 'kanata.exe'
$ConfigPath         = Join-Path $InstallDir $ConfigName

$srcConfig = Join-Path $PSScriptRoot $ConfigName
if (-not (Test-Path $srcConfig)) {
    throw "$ConfigName not found next to install.ps1 - run the script from a clone/download of the repo."
}

$tmp = Join-Path $env:TEMP "kanata-install-$(Get-Random)"
New-Item -ItemType Directory -Path $tmp | Out-Null

try {
    # Stop a running kanata so its exe can be replaced
    Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue |
        Stop-ScheduledTask -ErrorAction SilentlyContinue
    Get-Process kanata -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500

    Write-Host "Downloading kanata ($Variant variant)..."
    $kanataZip = Join-Path $tmp 'kanata.zip'
    Invoke-WebRequest $KanataZipUrl -OutFile $kanataZip
    Expand-Archive $kanataZip -DestinationPath (Join-Path $tmp 'kanata')

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item (Join-Path $tmp "kanata\kanata_windows_gui_${Variant}_x64.exe") $KanataExe -Force
    Copy-Item $srcConfig $ConfigPath -Force
    Unblock-File $KanataExe

    $rebootNeeded = $false
    if ($Variant -eq 'wintercept') {
        Write-Host 'Downloading the Interception driver...'
        $interceptionZip = Join-Path $tmp 'interception.zip'
        Invoke-WebRequest $InterceptionZipUrl -OutFile $interceptionZip
        Expand-Archive $interceptionZip -DestinationPath $tmp

        # kanata needs the user-mode library next to its exe;
        # keep the installer around for uninstall.ps1 -RemoveDriver
        Copy-Item (Join-Path $tmp 'Interception\library\x64\interception.dll') $InstallDir -Force
        Copy-Item (Join-Path $tmp 'Interception\command line installer\install-interception.exe') $InstallDir -Force

        # the driver registers kernel services named "keyboard" and "mouse"
        if (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Services\keyboard') {
            Write-Host 'Interception driver is already installed.'
        }
        else {
            Write-Host 'Installing the Interception driver...'
            $p = Start-Process (Join-Path $InstallDir 'install-interception.exe') `
                -ArgumentList '/install' -Wait -PassThru -NoNewWindow
            if ($p.ExitCode -ne 0) {
                throw "Interception driver installation failed (exit code $($p.ExitCode))."
            }
            $rebootNeeded = $true
        }
    }
    else {
        # leftover from an earlier wintercept install - the winIOv2 exe never loads it
        Remove-Item (Join-Path $InstallDir 'interception.dll') -Force -ErrorAction SilentlyContinue

        if (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Services\keyboard') {
            Write-Warning 'The Interception driver is still installed but kanata no longer uses it. Remove it with: uninstall.ps1 -RemoveDriver'
        }
    }

    Write-Host 'Validating the config...'
    $p = Start-Process $KanataExe -ArgumentList '--cfg', "`"$ConfigPath`"", '--check' -Wait -PassThru
    if ($p.ExitCode -ne 0) {
        throw "Config validation failed. Run manually: `"$KanataExe`" --cfg `"$ConfigPath`" --check"
    }

    if (-not $NoAutostart) {
        Write-Host 'Registering the autostart task...'
        $action   = New-ScheduledTaskAction -Execute $KanataExe -Argument "--cfg `"$ConfigPath`""
        $trigger  = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) `
            -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
            -Settings $settings -RunLevel Highest -Force | Out-Null
    }

    if ($rebootNeeded) {
        Write-Host ''
        Write-Host 'Done. REBOOT REQUIRED to activate the Interception driver.' -ForegroundColor Yellow
        Write-Host 'kanata will start automatically after you log back in.'
    }
    else {
        if (-not $NoAutostart) {
            Start-ScheduledTask -TaskName $TaskName
        }
        else {
            Start-Process $KanataExe -ArgumentList '--cfg', "`"$ConfigPath`""
        }
        Write-Host ''
        Write-Host 'Done. kanata is running (look for the tray icon).' -ForegroundColor Green
    }
    Write-Host "Installed to: $InstallDir"
}
finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
