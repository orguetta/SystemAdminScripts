# This script sends email notifications to users in a domain to remind them to change their passwords before they expire.
# It checks the password expiration date for each user and sends an email notification if the password is about to expire.

import-module ActiveDirectory;

$fromemail = "password@example.com"
$smtpserver = "smtp.example.com"
$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

# Function to send email notification
function Send-EmailNotification {
    param (
        [string]$UserName,
        [string]$Email,
        [int]$DaysLeft
    )
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
    try {
        Send-MailMessage -To $Email -From $fromemail -Subject "Reminder: PASSWORD will expire in $DaysLeft days" -Body $WarnMsg -SmtpServer $smtpserver -BodyAsHtml
        Write-Host "Email sent to $Email successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error sending email to $Email: $_" -ForegroundColor Red
    }
}

# Main script execution
try {
    Get-ADUser -Filter * -Properties PasswordLastSet, PasswordExpired, PasswordNeverExpires, EmailAddress, GivenName | ForEach-Object {
        $today = Get-Date
        $UserName = $_.GivenName
        $Email = $_.EmailAddress

        if (!$_.PasswordExpired -and !$_.PasswordNeverExpires) {
            $ExpiryDate = $_.PasswordLastSet + $maxPasswordAgeTimeSpan
            $DaysLeft = ($ExpiryDate - $today).Days

            if ($DaysLeft -eq 14 -or $DaysLeft -eq 7 -or $DaysLeft -eq 1) {
                ForEach ($email in $Email) {
                    Send-EmailNotification -UserName $UserName -Email $email -DaysLeft $DaysLeft
                }
            }
        }
    }
    Write-Host "Password expiration notification process completed." -ForegroundColor Cyan
} catch {
    Write-Host "Error processing password expiration notifications: $_" -ForegroundColor Red
}
