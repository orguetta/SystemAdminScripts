# This script is designed to delete old files from a specified directory.
# It deletes files that are older than a specified number of days.
# The script includes error handling to manage potential issues during execution.
# Logging is added to record important events and errors for troubleshooting purposes.

# Set the path to the directory and the number of days to keep the files.
$directoryPath = "C:\Temp"
$daysToKeep = 30
$limit = (Get-Date).AddDays(-$daysToKeep)

# Function to delete old files and handle errors.
function Delete-OldFiles {
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
                Add-Content -Path "C:\Temp\DeleteOldFiles.log" -Value "Deleted file: $($_.FullName) at $(Get-Date)"
            } catch {
                Write-Host "Error deleting file: $($_.FullName)" -ForegroundColor Red
                # Log the error
                Add-Content -Path "C:\Temp\DeleteOldFiles.log" -Value "Error deleting file: $($_.FullName) at $(Get-Date) - $($_.Exception.Message)"
            }
        }
    } catch {
        Write-Host "Error processing files in path: $path" -ForegroundColor Red
        # Log the error
        Add-Content -Path "C:\Temp\DeleteOldFiles.log" -Value "Error processing files in path: $path at $(Get-Date) - $($_.Exception.Message)"
    }
}

# Main script execution
Write-Host "Starting file deletion..." -ForegroundColor Cyan
# Log the start of the file deletion process
Add-Content -Path "C:\Temp\DeleteOldFiles.log" -Value "Starting file deletion at $(Get-Date)"
Delete-OldFiles -path $directoryPath -dateLimit $limit
Write-Host "File deletion completed." -ForegroundColor Cyan
# Log the completion of the file deletion process
Add-Content -Path "C:\Temp\DeleteOldFiles.log" -Value "File deletion completed at $(Get-Date)"
