# Define the path to the file
$filePath = "C:\Windows\System32\IntegratedServicesRegionPolicySet.json"

# Define the user or group to grant permissions to
$userOrGroup = $env:USERNAME  # Replace <username> with the actual user or group

# Get the current ACL of the file
$acl = Get-Acl -Path $filePath

# Define the new permission rule
$permission = $userOrGroup, "FullControl", "Allow"

# Create the new access rule
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission

# Add the new access rule to the ACL
$acl.AddAccessRule($accessRule)

# Apply the updated ACL to the file
Set-Acl -Path $filePath -AclObject $acl

# Define the file path
$filePath = "C:\Windows\System32\IntegratedServicesRegionPolicySet.json"

# Define the line number and the text to replace
$lineNumber = 8 # Line number (1-based)
$oldText = "disabled"
$newText = "enabled"

# Read the file content into an array of lines
$lines = Get-Content -Path $filePath

# Check if the line number is valid
if ($lineNumber -le $lines.Length -and $lineNumber -gt 0) {
    # Replace text on the specified line
    $lines[$lineNumber - 1] = $lines[$lineNumber - 1] -replace [regex]::Escape($oldText), $newText

    # Write the modified content back to the file
    Set-Content -Path $filePath -Value $lines
} else {
    Write-Error "Line number $lineNumber is out of range."
}

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge"
$valueName = "NoRemove"

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Get the current value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

    # Check if the value exists and is currently set to 1
    if ($currentValue -and $currentValue.$valueName -eq 1) {
        # Set the new value to 0
        Set-ItemProperty -Path $registryPath -Name $valueName -Value 0
        Write-Output "The registry value '$valueName' has been updated from 1 to 0."
    } else {
        Write-Output "The registry value '$valueName' is not set to 1 or does not exist."
    }
} else {
    Write-Output "The registry path '$registryPath' does not exist."
}
# Credit to Sander Holvoet (finding edge version folder to access setup.exe)
$EdgeVersion = (Get-AppxPackage "Microsoft.MicrosoftEdge.Stable" -AllUsers).Version
$EdgeSetupPath = ${env:ProgramFiles(x86)} + '\Microsoft\Edge\Application\' + $EdgeVersion + '\Installer\setup.exe'
& $EdgeSetupPath  --uninstall --msedge --channel=stable --system-level --verbose-logging