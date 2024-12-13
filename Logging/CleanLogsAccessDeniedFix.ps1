# This script is designed to fix access denied errors when cleaning up log files.
# It attempts to delete log files and handles access denied errors by taking ownership of the files and retrying the deletion.
# The script includes error handling to manage potential issues during execution.
# Logging is added to record important events and errors for troubleshooting purposes.

# Set the path to the log files and the number of days to keep the files.
$logPath = "C:\Logs"
$daysToKeep = 30
$limit = (Get-Date).AddDays(-$daysToKeep)

# Function to take ownership of a file.
function Take-Ownership {
    param (
        [string]$filePath
    )
    try {
        $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $takeown = Start-Process -FilePath "takeown.exe" -ArgumentList "/F `"$filePath`"" -Wait -NoNewWindow -PassThru
        $icacls = Start-Process -FilePath "icacls.exe" -ArgumentList "`"$filePath`" /grant `$user`:F" -Wait -NoNewWindow -PassThru
        Write-Host "Ownership taken for file: $filePath" -ForegroundColor Green
        # Log the ownership change
        Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Ownership taken for file: $filePath at $(Get-Date)"
    } catch {
        Write-Host "Error taking ownership of file: $filePath" -ForegroundColor Red
        # Log the error
        Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Error taking ownership of file: $filePath at $(Get-Date) - $($_.Exception.Message)"
    }
}

# Function to delete old log files and handle access denied errors.
function Delete-OldLogs {
    param (
        [string]$path,
        [datetime]$dateLimit
    )
    try {
        Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $dateLimit } | ForEach-Object {
            try {
                Remove-Item -Path $_.FullName -Force
                Write-Host "Deleted file: $($_.FullName)" -ForegroundColor Green
                # Log the deletion of the file
                Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Deleted file: $($_.FullName) at $(Get-Date)"
            } catch {
                if ($_.Exception -match "Access to the path") {
                    Write-Host "Access denied for file: $($_.FullName). Attempting to take ownership." -ForegroundColor Yellow
                    # Log the access denied error
                    Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Access denied for file: $($_.FullName) at $(Get-Date)"
                    Take-Ownership -filePath $_.FullName
                    try {
                        Remove-Item -Path $_.FullName -Force
                        Write-Host "Deleted file after taking ownership: $($_.FullName)" -ForegroundColor Green
                        # Log the deletion of the file after taking ownership
                        Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Deleted file after taking ownership: $($_.FullName) at $(Get-Date)"
                    } catch {
                        Write-Host "Error deleting file after taking ownership: $($_.FullName)" -ForegroundColor Red
                        # Log the error
                        Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Error deleting file after taking ownership: $($_.FullName) at $(Get-Date) - $($_.Exception.Message)"
                    }
                } else {
                    Write-Host "Error deleting file: $($_.FullName)" -ForegroundColor Red
                    # Log the error
                    Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Error deleting file: $($_.FullName) at $(Get-Date) - $($_.Exception.Message)"
                }
            }
        }
    } catch {
        Write-Host "Error processing log files in path: $path" -ForegroundColor Red
        # Log the error
        Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Error processing log files in path: $path at $(Get-Date) - $($_.Exception.Message)"
    }
}

# Main script execution
Write-Host "Starting log cleanup..." -ForegroundColor Cyan
# Log the start of the log cleanup process
Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Starting log cleanup at $(Get-Date)"
Delete-OldLogs -path $logPath -dateLimit $limit
Write-Host "Log cleanup completed." -ForegroundColor Cyan
# Log the completion of the log cleanup process
Add-Content -Path "C:\Logs\CleanLogsAccessDeniedFix.log" -Value "Log cleanup completed at $(Get-Date)"
