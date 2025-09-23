
# Define expected installation paths
$officePaths = @(
    "$env:ProgramFiles\Microsoft Office",
    "${env:ProgramFiles(x86)}\Microsoft Office",
    "$env:ProgramFiles\Microsoft Office\root\Office16",
    "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16",
    "$env:LOCALAPPDATA\Microsoft",
    "$env:LOCALAPPDATA\Microsoft\WindowsApps\",
    "$env:ProgramFiles\Huntress\",
    "${env:ProgramFiles(x86)}\CentraStage"
    "$env:LOCALAPPDATA\Microsoft\Outlook"
    "$env:ProgramFiles\Irradiant eFiler (x64 edition)"
)

$sharepointCaches = @(
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients A-C",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients D-F",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients G-I",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients J-L",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients M-O",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients P-R",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients S-U",
    "$env:USERPROFILE\Part B Group LTD\Client Documents - Clients V-Z",
    "$env:USERPROFILE\Part B Group LTD\Technical Documents"
)

foreach ($path in $sharepointCaches) {
    if (Test-Path $path) {
        Write-Host "$path exists" -ForegroundColor Green
    } else {
        Write-Host "$path does NOT exist" -ForegroundColor Red
    }
}

# Define application executables relative to base paths
$apps = @{
    "Word"    = "WINWORD.EXE"
    "Excel"   = "EXCEL.EXE"
    "Outlook" = "OUTLOOK.EXE"
    "Teams"   = "ms-teams.exe"
    "Huntress" = "HuntressAgent.exe"
    "Datto" = "Gui.exe"
    "Outlook Mailbox" = "*.ost"
    "eFiler" = "efiler.exe"
}

# Check KB Language
$kbLang = (Get-WinUserLanguageList)[0].LanguageTag

# Check Machine Name

$computerName = $env:COMPUTERNAME

if ($computerName -like "PAB-*") {
    Write-Host "Computer name is $computerName (starts with PAB-)" -ForegroundColor Green
} else {
    Write-Host "Computer name is $computerName (does NOT start with PAB-)" -ForegroundColor Red
}

# Check OS Language
$osLang = (Get-WinSystemLocale).Name


# Check each sharepoint path
foreach ($app in $apps.Keys) {
    $found = $false
    foreach ($base in $officePaths) {
        $fullPath = Join-Path $base $apps[$app]
        # Write-Host "Checking path: $fullPath"
        if (Test-Path $fullPath) {
            $found = $true
            break
        }
    }
    Write-Host "$app " -NoNewline
    if ($found) {
        Write-Host "Installed" -ForegroundColor Green
    } else {
        Write-Host "Not Installed" -ForegroundColor Red
    }
}

# Check BitLocker Status
$bitlockerStatus = Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty ProtectionStatus

# Output Results

Write-Host "BitLocker Status on C: is" -NoNewline
if ($bitlockerStatus -eq "on"){
    Write-Host " $bitlockerstatus" -ForegroundColor Green
}
else {
    Write-Host " unknown" -ForegroundColor Red
}

Write-Host "Keyboard Language is set to" -NoNewline
if ($kbLang -eq "en-GB"){
    Write-Host " $kbLang" -ForegroundColor Green
}
else {
    Write-Host " unknown" -ForegroundColor Red
}

Write-Host "OS Language is set to" -NoNewline
if ($osLang -eq "en-GB"){
    Write-Host " $osLang" -ForegroundColor Green
}
else {
    Write-Host " unknown" -ForegroundColor Red
}
