$users = Read-Host 'Enter Username of Profile to Delete'
$PServers = @("Server1", "Server2")
foreach ($server in $PServers) {
    try {
        (Get-WmiObject Win32_UserProfile -ComputerName $server | Where-Object { $_.LocalPath -like "c:\users\$users" }).Delete()
        if ($null -ne $users) {
            $Folder = "\\$server\RoamingProfile\$users.V2"
            if (Test-Path $Folder) {
                takeown /f $Folder /r /d y
                Remove-Item $Folder -Recurse -Force
            }
        }
        Write-Host "$users deleted successfully on $server"
    } catch {
        Write-Host "Error for $users from $server - Error $($_.Exception.Message)"
    }
}