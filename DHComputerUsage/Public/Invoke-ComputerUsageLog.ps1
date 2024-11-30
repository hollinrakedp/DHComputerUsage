function Invoke-ComputerUsageLog {
    <#
    .SYNOPSIS
    Tracks user logon, logoff, unlock, and lock events.

    .DESCRIPTION
    This function logs user activity events such as logon, logoff, unlock, and lock to a specified log file.
    The log file is created in the specified log path if it does not already exist.

    .NOTES
    Name       : Invoke-ComputerUsageLog
    Author     : Darren Hollinrake
    Version    : 1.0.0
    DateCreated: 2024-11-29
    DateUpdated: 

    .PARAMETER Type
    The type of event to log. Valid values are "Logon", "Logoff", "Unlock", and "Lock".

    .PARAMETER LogPath
    The path where the log file will be stored. If no value is supplied, it will default to "C:\Temp".

    .PARAMETER LogFile
    The name of the log file. Defaults to "ComputerUsage_$env:COMPUTERNAME.log".

    .EXAMPLE
    Invoke-ComputerUsageLog -Type Logon

    Logs a logon event to the default log file in the default log path.

    .EXAMPLE
    Invoke-ComputerUsageLog -Type Logoff -LogPath "D:\Logs" -LogFile "CustomLog.log"

    Logs a logoff event to "D:\Logs\CustomLog.log".

    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet("Logon", "Logoff", "Unlock", "Lock")]
        $Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        $LogPath = "C:\Temp",

        [Parameter(ValueFromPipelineByPropertyName)]
        $LogFile = "ComputerUsage_$env:COMPUTERNAME.log"
    )

    $Log = Join-Path -Path $LogPath -ChildPath $LogFile

    try {
        if (-not (Test-Path $LogPath)) {
            New-Item -Path $LogPath -ItemType Directory | Out-Null
        }
    }
    catch {
        Write-Error "Failed to create or access log path: $_"
        return
    }

    "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")`t$env:COMPUTERNAME`t$env:USERNAME`t$Type" | Out-File -FilePath $Log -Append
}