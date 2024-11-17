import-module ActiveDirectory;

$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
$WarnMsg = Get-Content \\Server\Files\password.htm -Raw
$FromEmail='Password@example.com'
$SmtpServer='smtp.example.com'

Get-ADUser -filter 'PasswordNeverExpires -ne $true' -properties PasswordLastSet, PasswordExpired, PasswordNeverExpires, EmailAddress, GivenName | foreach {
 
    $today=get-date
    $UserName=$_.GivenName
    $Email=$_.EmailAddress
    
    if (!$_.PasswordExpired -and !$_.PasswordNeverExpires) {
 
        $ExpiryDate=$_.PasswordLastSet + $maxPasswordAgeTimeSpan
        $DaysLeft=($ExpiryDate-$today).days 
 
        if ($DaysLeft -eq 21 -or $DaysLeft -eq 14 -or $DaysLeft -lt 8){
 
        
ForEach ($email in $_.EmailAddress) {  
send-mailmessage -to $Email -from $FromEmail -Subject "Your password will be to expired in $daysleft days" -Body $WarnMsg -Encoding utf8 -SmtpServer $SmtpServer -BodyAsHtml  }


            }
 
    }
}