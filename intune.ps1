Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-Module Microsoft.Graph -Force
Connect-MgGraph -Scopes "DeviceManagementServiceConfig.ReadWrite.All"
##Log in with Intune account
Install-script Get-WindowsAutopilotInfo -verbose
get-WindowsAutopilotInfo -online
restart-computer -force
