import-module ActiveDirectory
$date = Get-Date

$ou1 = Get-ADUser -Filter 'enabled -eq $true' -SearchBase "OU=Department1,DC=Example,DC=com" -Properties lastlogondate | ? {$_.distinguishedname -notlike "*OU=Department2,OU=Users,OU=Department1,DC=Example,DC=com*"}
$date30 = $date.AddDays(-30)
$ou1 | ? {$_.lastlogondate -lt $date30} | export-csv C:\path\to\csv\inactive_users_ou1.csv

$ou2 = Get-ADUser -Filter 'enabled -eq $true' -SearchBase "OU=Department2,OU=Users,OU=Department1,DC=Example,DC=com" -Properties lastlogondate
$date14 = $date.AddDays(-14)
$ou2 | ? {$_.lastlogondate -lt $date14} | export-csv C:\path\to\csv\inactive_users_ou2.csv