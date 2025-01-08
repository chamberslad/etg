Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module Microsoft.Graph -Force
Connect-MgGraph -Scopes "DeviceManagementServiceConfig.ReadWrite.All"
##Log in with Intune account
Install-script Get-WindowsAutopilotInfo -verbose
get-WindowsAutopilotInfo -online
Write-Host "Navigate to the M3656 tenant and if needed assign the correct Enrolment profile to the device via Entra group.  When ready push Y to continue.  This WILL REBOOT the deivce." -ForegroundColor Green
do {
    $key = Read-Host
} while ($key -ne 'y')
restart-computer -force
