#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Applies config changes: validates mac-win-shortcuts.kbd from the repo,
    copies it to the install directory and restarts kanata.

    Use after editing the .kbd. Does not re-download kanata itself;
    re-run install.ps1 for that.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File update.ps1
#>
param(
    [string]$InstallDir = "$env:LOCALAPPDATA\kanata"
)

$ErrorActionPreference = 'Stop'
$ConfigName = 'mac-win-shortcuts.kbd'
$TaskName   = 'kanata'
$KanataExe  = Join-Path $InstallDir 'kanata.exe'
$srcConfig  = Join-Path $PSScriptRoot $ConfigName

if (-not (Test-Path $KanataExe)) {
    throw "kanata not found in $InstallDir - run install.ps1 first."
}
if (-not (Test-Path $srcConfig)) {
    throw "$ConfigName not found next to update.ps1 - run the script from the repo folder."
}

Write-Host 'Validating the config...'
$p = Start-Process $KanataExe -ArgumentList '--cfg', "`"$srcConfig`"", '--check' -Wait -PassThru
if ($p.ExitCode -ne 0) {
    throw "Config validation failed, kanata was NOT restarted. Run manually: `"$KanataExe`" --cfg `"$srcConfig`" --check"
}

Copy-Item $srcConfig (Join-Path $InstallDir $ConfigName) -Force

Write-Host 'Restarting kanata...'
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue |
    Stop-ScheduledTask -ErrorAction SilentlyContinue
Get-Process kanata -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500

if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Start-ScheduledTask -TaskName $TaskName
}
else {
    Start-Process $KanataExe -ArgumentList '--cfg', "`"$(Join-Path $InstallDir $ConfigName)`""
}

Write-Host 'Config updated, kanata restarted.' -ForegroundColor Green
