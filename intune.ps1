Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-Module Microsoft.Graph -Force
Install-Module Microsoft.Graph.Authentication -Force
Install-Module Microsoft.Graph.Groups -Force
Connect-MgGraph -Scopes "DeviceManagementServiceConfig.ReadWrite.All"
##Log in with Intune account
Install-script Get-WindowsAutopilotInfo -verbose
get-WindowsAutopilotInfo -online
restart-computer -force
