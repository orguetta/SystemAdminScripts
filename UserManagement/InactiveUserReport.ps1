# This script generates a report of inactive users in specific organizational units (OUs) in Active Directory.
# It checks the last logon date for each user and exports the list of inactive users to CSV files.

import-module ActiveDirectory

# Get the current date
$date = Get-Date

# Define the organizational units (OUs) to check for inactive users
$ou1 = Get-ADUser -Filter 'enabled -eq $true' -SearchBase "OU=Department1,DC=Example,DC=com" -Properties lastlogondate | ? {$_.distinguishedname -notlike "*OU=Department2,OU=Users,OU=Department1,DC=Example,DC=com*"}
$ou2 = Get-ADUser -Filter 'enabled -eq $true' -SearchBase "OU=Department2,OU=Users,OU=Department1,DC=Example,DC=com" -Properties lastlogondate

# Define the inactivity periods for each OU
$date30 = $date.AddDays(-30)
$date14 = $date.AddDays(-14)

# Export the list of inactive users to CSV files
try {
    $ou1 | ? {$_.lastlogondate -lt $date30} | Export-Csv C:\path\to\csv\inactive_users_ou1.csv -NoTypeInformation
    Write-Host "Inactive users in OU1 exported successfully." -ForegroundColor Green
} catch {
    Write-Host "Error exporting inactive users in OU1: $_" -ForegroundColor Red
}

try {
    $ou2 | ? {$_.lastlogondate -lt $date14} | Export-Csv C:\path\to\csv\inactive_users_ou2.csv -NoTypeInformation
    Write-Host "Inactive users in OU2 exported successfully." -ForegroundColor Green
} catch {
    Write-Host "Error exporting inactive users in OU2: $_" -ForegroundColor Red
}
