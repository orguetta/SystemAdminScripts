# This script sends an email alert if a user gets locked out of the Active Directory system.
# It checks the latest log entry for event ID 4740, which indicates a user account lockout.
# If such an event is found, it sends an email notification with the event details.

# Get the latest log entry from the Security log with event ID 4740
try {
    $event = Get-EventLog -LogName Security -Source "Microsoft-Windows-Security-Auditing" -InstanceID "4740" -Newest 1 | Format-List -Property * | Out-String
    Write-Host "Event retrieved successfully." -ForegroundColor Green
} catch {
    Write-Host "Error retrieving event: $_" -ForegroundColor Red
    Exit
}

# Prepare the email details
$EmailBody = $event
$EmailFrom = "<admin@example.com>"
$EmailTo = "logs@example.com"
$EmailSubject = "Account got locked"
$SMTPServer = "smtp.example.com"

# Send the email notification
try {
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $SMTPServer
    Write-Host "Email sent successfully." -ForegroundColor Green
} catch {
    Write-Host "Error sending email: $_" -ForegroundColor Red
}

Exit
