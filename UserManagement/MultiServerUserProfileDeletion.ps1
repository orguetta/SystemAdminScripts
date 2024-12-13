# This script deletes user profiles from multiple servers.
# It takes a username as input and deletes the corresponding user profile from the specified servers.

# Prompt the user to enter the username of the profile to delete
$users = Read-Host 'Enter Username of Profile to Delete'

# Define the list of servers to delete the user profile from
$PServers = @("Server1", "Server2")

# Loop through each server and delete the user profile
foreach ($server in $PServers) {
    try {
        # Delete the user profile from the server
        (Get-WmiObject Win32_UserProfile -ComputerName $server | Where-Object { $_.LocalPath -like "c:\users\$users" }).Delete()
        
        # Check if the user profile folder exists and delete it
        if ($null -ne $users) {
            $Folder = "\\$server\RoamingProfile\$users.V2"
            if (Test-Path $Folder) {
                takeown /f $Folder /r /d y
                Remove-Item $Folder -Recurse -Force
            }
        }
        Write-Host "$users deleted successfully on $server" -ForegroundColor Green
    } catch {
        Write-Host "Error deleting $users from $server - Error $($_.Exception.Message)" -ForegroundColor Red
    }
}
