#This script sends email if a user get locked-out of Active Directory system
#
$event = get-eventlog -LogName Security -source "Microsoft-Windows-Security-Auditing" -InstanceID "4740" -newest 1 | Format-List -Property * | Out-String
    $EmailBody = $event
    $EmailFrom = "<admin@example.com>"
    $EmailTo = “logs@example.com" 
    $EmailSubject = "account got locked"
    $SMTPServer = "smtp.example.com"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer
Exit
