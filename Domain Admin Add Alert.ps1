#This script sends email if a user is added to the "domain admins" group of Active Directory system
#
#finds this eventid of added to domain admins group!!! -checks latest 100 last logons in case many
#users are added. eventID 4728
#
#wait 10 seconds in case more users are added:
Start-Sleep -s 10
$events = get-eventlog -logname Security  -InstanceID "4728" -newest 100
$event2 = $events | select-string -inputobject {$_.message} -pattern "domain admins"
  
    $EmailBody = $event2
    $EmailFrom = "<admin@consumerphysics.com>"
    $EmailTo = “logs@consumerphysics.com" 
    $EmailSubject = "a user was added to domain admins"
    $SMTPServer = "aspmx.l.google.com"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer
Exit
