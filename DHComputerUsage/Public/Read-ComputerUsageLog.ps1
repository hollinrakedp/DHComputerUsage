function Read-ComputerUsageLog {
    <#
    .SYNOPSIS
    Reads and processes the usage tracker log.

    .DESCRIPTION
    This function reads the usage tracker log file and processes its contents into objects.

    .NOTES
    Name       : Read-ComputerUsageLog
    Author     : Darren Hollinrake
    Version    : 1.0.0
    DateCreated: 2024-11-29
    DateUpdated: 

    .PARAMETER LogPath
    The path to the usage tracker log file.

    .Parameter Last
    The number of log entries to read from the end of the log file.

    .EXAMPLE
    Read-ComputerUsageLog -LogPath "C:\Logs\UsageTracker.log"

    This command reads the usage tracker log file located at "C:\Logs\UsageTracker.log".

    .EXAMPLE
    Read-ComputerUsageLog -LogPath "C:\Logs\UsageTracker.log" -Last 10

    This command reads the last 10 log entries from the usage tracker log file located at "C:\Logs\UsageTracker.log".

    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$LogPath,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$Last = 0
    )

    if (! (Test-Path $LogPath)) {
        Write-Error "Log file not found: $LogPath"
        return
    }

    if ($Last -gt 0) {
        $LogEntries = Get-Content -Path $LogPath -Tail $Last
    }
    else {
        $LogEntries = Get-Content -Path $LogPath
    }

    foreach ($Entry in $LogEntries) {
        $EntrySplit = $Entry -split "`t"
        $logObject = [PSCustomObject]@{
            Date         = [datetime]$EntrySplit[0]
            ComputerName = $EntrySplit[1]
            UserName     = $EntrySplit[2]
            Type         = $EntrySplit[3]
        }
        $LogObject
    }
}