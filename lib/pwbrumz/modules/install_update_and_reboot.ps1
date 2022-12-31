#> This module will install all the updates and reboot the server
#> It will install PSWindowsUpdate and NuGet
#> Internet connexion is required


# Function to check pending reboot.
function Check-PendingReboot {
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
    try { 
        $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
        $status = $util.DetermineIfRebootPending()
        if (($status -ne $null) -and $status.RebootPending) {
            return $true
        }
    }
    catch { }

    return $false
}


# Install the required packages.
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force

# Import the required module.
Import-Module PSWindowsUpdate

# Look for all updates, download, install and don't reboot yet.
Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot

# Check if a pending reboot is found, notify users if that is the case. If none found just close the session.
$reboot = Check-PendingReboot

if($reboot -eq $true){
   write-host("Pending reboot found. Reboot..")
   cmd /c "msg * "Windows update has finished downloading and needs to reboot to install the required updates. Rebooting in 5 minutes..""
   cmd /c "Shutdown /r /f /t 300"
   Exit
   
}else {
   write-host("No Pending reboot. Shutting down PowerShell..")
   Exit
}