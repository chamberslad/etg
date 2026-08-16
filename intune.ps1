Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module Microsoft.Graph -Force
Connect-MgGraph -Scopes "DeviceManagementServiceConfig.ReadWrite.All"
## Log in with Intune Administrator account when prompted
Install-Script Get-WindowsAutopilotInfo -Verbose
Get-WindowsAutopilotInfo -Online
 
Write-Host "`nDevice hash uploaded successfully." -ForegroundColor Green
Write-Host "Before pressing Y, confirm the following in the M3656 Intune tenant:`n" -ForegroundColor Green
 
Write-Host "  STEP 1 - Confirm device has registered:" -ForegroundColor Cyan
Write-Host "    > Intune > Devices > Enrol devices > Windows enrollment > Devices" -ForegroundColor Green
Write-Host "    > Find this device by serial number and confirm it appears in the list`n" -ForegroundColor Green
 
Write-Host "  STEP 2 - Check profile assignment status:" -ForegroundColor Cyan
Write-Host "    > In the same view, check the 'Profile status' column" -ForegroundColor Green
Write-Host "    > If it shows 'Assigned' proceed to Step 4" -ForegroundColor Green
Write-Host "    > If it shows 'Pending' wait 5 mins and refresh - continue to Step 3 if still Pending`n" -ForegroundColor Green
 
Write-Host "  STEP 3 - If still Pending, check the dynamic group in Entra:" -ForegroundColor Cyan
Write-Host "    > Entra ID > Groups > find your Autopilot group" -ForegroundColor Green
Write-Host "    > Click Members - confirm this device appears in the group" -ForegroundColor Green
Write-Host "    > If not present, click Membership rules and validate the rule is correct" -ForegroundColor Green
Write-Host "    > If device is in the group, go to Intune > Devices > Enrol devices > Deployment profiles" -ForegroundColor Green
Write-Host "    > Open the profile > Assignments > confirm the Autopilot group is listed`n" -ForegroundColor Green
 
Write-Host "  STEP 4 - Ready to proceed:" -ForegroundColor Cyan
Write-Host "    > Profile status must show 'Assigned' before continuing" -ForegroundColor Green
Write-Host "    > Do NOT proceed if status is still Pending - the device will not enrol correctly`n" -ForegroundColor Green
 
Write-Host "When Profile Status = Assigned, type Y and press Enter to reboot.`n" -ForegroundColor Yellow
 
do {
    $key = Read-Host
} while ($key -ne 'y')
 
Restart-Computer -Force
