# SystemAdminScripts

Scripts for System administrator & system security administrator

## Purpose and Usage

This repository contains various scripts designed to assist system administrators and system security administrators in managing and securing their environments. The scripts cover a range of tasks, including log management, user management, and security tasks.

## Subdirectories

The scripts in this repository are organized into subdirectories based on their functionality:

- `Logging`: Contains scripts related to log management, such as cleaning up old log files and deleting old files.
- `Security`: Contains scripts related to security tasks, such as sending alerts for domain admin additions and user lockouts, as well as notifying users about password expiration.
- `UserManagement`: Contains scripts related to user management, such as generating reports on inactive users and deleting user profiles across multiple servers.

## Usage

1. Ensure you have the necessary permissions to run the scripts and access the required resources.
2. Update the scripts with the appropriate settings, such as email addresses, SMTP servers, and file paths.
3. Run the scripts as needed to perform the desired tasks.

## Requirements

- PowerShell
- Active Directory module for PowerShell (for scripts that interact with Active Directory)
- Access to an SMTP server for sending email notifications (for scripts that send emails)
