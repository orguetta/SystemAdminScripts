# This script sends an email alert if a user is added to the "domain admins" group in an Active Directory system.
# It checks the latest 100 log entries for event ID 4728, which indicates a user was added to the "domain admins" group.
# If such an event is found, it sends an email notification with the event details.

# Wait 10 seconds in case more users are added
Start-Sleep -s 10

# Get the latest 100 log entries from the Security log with event ID 4728
$events = Get-EventLog -LogName Security -InstanceID "4728" -Newest 100

# Filter the events to find those related to the "domain admins" group
$event2 = $events | Select-String -InputObject {$_.Message} -Pattern "domain admins"

# Prepare the email details
$EmailBody = $event2
$EmailFrom = "<alert@example.com>"
$EmailTo = "logs@example.com"
$EmailSubject = "A user was added to domain admins"
$SMTPServer = "smtp.example.com"

# Send the email notification
try {
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $SMTPServer
    Write-Host "Email sent successfully." -ForegroundColor Green
} catch {
    Write-Host "Error sending email: $_" -ForegroundColor Red
}

Exit
