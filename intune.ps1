# Function to check and set registry value
function Set-RegistryValueIfNotExists {
    param (
        [string]$path,
        [string]$name,
        [int]$value
    )
    
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    
    if (-not (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue)) {
        # FIX: New-ItemProperty instead of Set-ItemProperty -Type
        New-ItemProperty -Path $path -Name $name -Value $value -PropertyType DWord -Force | Out-Null
        Write-Output "Set $name to $value at $path"
    } else {
        Write-Output "$name already exists at $path"
    }
}

# Function to query and display registry value
function Get-RegistryValue {
    param (
        [string]$path,
        [string]$name
    )
    
    $value = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
    if ($value) {
        Write-Output "$name at $path is set to $($value.$name)"
    } else {
        Write-Output "$name at $path does not exist"
    }
}

# --- Mount HKU drive if missing ---
if (-not (Get-PSDrive -Name HKU -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}

# Paths and value details
$pathHKLM = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$pathHKCU = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$pathHKU  = "HKU:\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

$valueName = "NoDriveTypeAutoRun"
$valueData = 255

# Disable Autoplay on all drives for HKLM, HKCU, and Default User
Set-RegistryValueIfNotExists -path $pathHKLM -name $valueName -value $valueData
Set-RegistryValueIfNotExists -path $pathHKCU -name $valueName -value $valueData
Set-RegistryValueIfNotExists -path $pathHKU  -name $valueName -value $valueData

# Query and display the registry values
Get-RegistryValue -path $pathHKLM -name $valueName
Get-RegistryValue -path $pathHKCU -name $valueName
Get-RegistryValue -path $pathHKU  -name $valueName

# Restart the computer to apply changes
# Restart-Computer
###############################################################################################################

# Rename Guest account
$newName = "Visitor"   # <-- Change this to the desired name

# Get the built-in Guest account (RID 501)
$guest = Get-LocalUser | Where-Object { $_.SID -like "*-501" }

if ($guest) {
    Rename-LocalUser -Name $guest.Name -NewName $newName
    Write-Output "Guest account renamed to '$newName'."
} else {
    Write-Output "Guest account not found."
}
###############################################################################################################

# Define registry paths
$lsaPath = "HKLM:\SYSTEM\CurrentControlSet\Control\LSA"
$lanmanPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

# Desired values
$desiredRestrictAnonymous = 1
$desiredRestrictNullSessAccess = 1

Write-Host "Checking registry settings..."

# Check RestrictAnonymous
$restrictAnonymous = Get-ItemProperty -Path $lsaPath -Name RestrictAnonymous -ErrorAction SilentlyContinue
if ($restrictAnonymous.RestrictAnonymous -ne $desiredRestrictAnonymous) {
    Write-Warning "RestrictAnonymous is $($restrictAnonymous.RestrictAnonymous), setting it to $desiredRestrictAnonymous"
    Set-ItemProperty -Path $lsaPath -Name RestrictAnonymous -Value $desiredRestrictAnonymous
} else {
    Write-Host "RestrictAnonymous is already set correctly ($desiredRestrictAnonymous)."
}

# Check RestrictNullSessAccess
$restrictNull = Get-ItemProperty -Path $lanmanPath -Name RestrictNullSessAccess -ErrorAction SilentlyContinue
if ($restrictNull.RestrictNullSessAccess -ne $desiredRestrictNullSessAccess) {
    Write-Warning "RestrictNullSessAccess is $($restrictNull.RestrictNullSessAccess), setting it to $desiredRestrictNullSessAccess"
    Set-ItemProperty -Path $lanmanPath -Name RestrictNullSessAccess -Value $desiredRestrictNullSessAccess
} else {
    Write-Host "RestrictNullSessAccess is already set correctly ($desiredRestrictNullSessAccess)."
}

Write-Host "Registry check and remediation complete."
###############################################################################################################

# Set CachedLogonsCount to 0
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regName = "CachedLogonsCount"
$regValue = "0"

# Check if the registry key exists
if (-not (Test-Path $regPath)) {
    Write-Error "Registry path not found: $regPath"
    exit 1
}

# Create or update the value
New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType String -Force | Out-Null

Write-Output "CachedLogonsCount set to $regValue at $regPath"
###############################################################################################################
