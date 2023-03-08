#> Get global server informations like OS version, last update installed, last reboot

$OSInfo = Get-CimInstance Win32_OperatingSystem
$LastBootTime = $OSInfo.LastBootUpTime
$InstallDate = $OSInfo.InstallDate
$LastBootTimeFormatted = $LastBootTime.ToLocalTime().ToString('MM/dd/yyyy hh:mm:ss tt')
$InstallDateFormatted = $InstallDate.ToLocalTime().ToString('MM/dd/yyyy hh:mm:ss tt')
$WindowsVersion = $OSInfo.Version
$WindowsBuild = $OSInfo.BuildNumber

Write-Host "Windows Version: $WindowsVersion, Build: $WindowsBuild" -ForegroundColor Green
Write-Host "Last Update Installed: $InstallDateFormatted" -ForegroundColor Green
Write-Host "Last Reboot: $LastBootTimeFormatted" -ForegroundColor Green
