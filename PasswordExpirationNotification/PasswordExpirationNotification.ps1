import-module ActiveDirectory;

$fromemail = "password@example.com"
$smtpserver = "smtp.example.com"
$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
 
Get-ADUser -filter * -properties PasswordLastSet, PasswordExpired, PasswordNeverExpires, EmailAddress, GivenName | ForEach-Object {
 
    $today=get-date
    $UserName=$_.GivenName
    $Email=$_.EmailAddress
 
    if (!$_.PasswordExpired -and !$_.PasswordNeverExpires) {
 
        $ExpiryDate=$_.PasswordLastSet + $maxPasswordAgeTimeSpan
        $DaysLeft=($ExpiryDate-$today).days 
 
        if ($DaysLeft -eq 14 -or $DaysLeft -eq 7 -or $DaysLeft -eq 1 ){
 
        $WarnMsg = "
<p style='font-family:calibri'>Hi $UserName,</p>
<p style='font-family:calibri'>Your login PASSWORD will expire in $DaysLeft days, please press CTRL+ALT+DELETE and change your password.  As a reminder, you will have to enter your new password into your DOMAIN connected mobile device if prompted.</p>


<p style='font-family:calibri'>Requirements for the password are as follows:</p>
<ul style='font-family:calibri'>
<li>Must not contain the user's account name or parts of the user's full name that exceed two consecutive characters</li>
<li>Must not be one of your last 7 passwords</li>
<li>Contain characters from three of the following four categories:</li>
<li>English uppercase characters (A through Z)</li>
<li>English lowercase characters (a through z)</li>
<li>Base 10 digits (0 through 9)</li>
<li>Non-alphabetic characters (for example, !, $, #, %)</li>
</ul>
<p style='font-family:calibri'> <a href='mailto:HelpDesk@example.com'> For assistance please contact me here </a></p>


<p style='font-family:calibri'>- Organization Name </p>
 
"
ForEach ($email in $_.EmailAddress) { 
send-mailmessage -to $email -from $fromemail -Subject " Reminder: PASSWORD will expire in $DaysLeft days  " -body $WarnMsg  -smtpserver $smtpserver -BodyAsHtml }


            }
 
    }
}