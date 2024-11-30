# DHComputerUsage

## Description
DHComputerUsage is a PowerShell module designed to track basic computer usage. It generates log entries for logon, logoff, lock, and unlock events for users.

## Installation
1. Add the module to a location in your PSModulePath.
1. Run ```Register-ComputerUsageTask``` to create 3 scheduled tasks (Logon, Lock, Unlock)
1. If you wish to track logoff, you will need to create a user-based Group Policy logoff script to call the 'Invoke-ComputerUsageLog' function with the type 'Logoff'.
   - An example 'Logoff.ps1' file can be found in the 'Data' directory.