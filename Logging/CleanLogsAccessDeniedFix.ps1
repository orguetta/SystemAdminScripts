# This script is designed to fix access denied errors when cleaning up log files.
# It attempts to delete log files and handles access denied errors by taking ownership of the files and retrying the deletion.

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
    } catch {
        Write-Host "Error taking ownership of file: $filePath" -ForegroundColor Red
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
            } catch {
                if ($_.Exception -match "Access to the path") {
                    Write-Host "Access denied for file: $($_.FullName). Attempting to take ownership." -ForegroundColor Yellow
                    Take-Ownership -filePath $_.FullName
                    try {
                        Remove-Item -Path $_.FullName -Force
                        Write-Host "Deleted file after taking ownership: $($_.FullName)" -ForegroundColor Green
                    } catch {
                        Write-Host "Error deleting file after taking ownership: $($_.FullName)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "Error deleting file: $($_.FullName)" -ForegroundColor Red
                }
            }
        }
    } catch {
        Write-Host "Error processing log files in path: $path" -ForegroundColor Red
    }
}

# Main script execution
Write-Host "Starting log cleanup..." -ForegroundColor Cyan
Delete-OldLogs -path $logPath -dateLimit $limit
Write-Host "Log cleanup completed." -ForegroundColor Cyan
