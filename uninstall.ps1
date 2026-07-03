#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Removes kanata installed by install.ps1: stops it, deletes the autostart
    task and the install directory. Pass -RemoveDriver to also uninstall the
    Interception driver (requires a reboot).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File uninstall.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -RemoveDriver
#>
param(
    [string]$InstallDir = "$env:LOCALAPPDATA\kanata",
    [switch]$RemoveDriver
)

$ErrorActionPreference = 'Stop'
$TaskName = 'kanata'

Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue |
    Stop-ScheduledTask -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Get-Process kanata -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500

if ($RemoveDriver) {
    $installer = Join-Path $InstallDir 'install-interception.exe'
    if (Test-Path $installer) {
        Write-Host 'Uninstalling the Interception driver...'
        Start-Process $installer -ArgumentList '/uninstall' -Wait -NoNewWindow
        Write-Host 'Reboot to finish removing the driver.' -ForegroundColor Yellow
    }
    else {
        Write-Warning "install-interception.exe not found in $InstallDir; download Interception.zip from https://github.com/oblitum/Interception/releases and run 'install-interception.exe /uninstall' manually."
    }
}

Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'kanata removed.' -ForegroundColor Green
