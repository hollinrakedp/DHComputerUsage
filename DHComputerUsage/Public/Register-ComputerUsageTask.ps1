function Register-ComputerUsageTask {
    <#
    .SYNOPSIS
    Registers the computer usage task.

    .DESCRIPTION
    This function registers the computer usage task with the Task Scheduler.

    .NOTES
    Name       : Register-ComputerUsageTask
    Author     : Darren Hollinrake
    Version    : 1.0.0
    DateCreated: 2024-11-29
    DateUpdated:

    .PARAMETER LogPath
    The path where the log file will be stored. If no value is supplied, it will default to "C:\Temp".

    .PARAMETER LogFile
    The name of the log file. If no value is supplied, it will default to "ComputerUsage_$env:COMPUTERNAME.log".

    .PARAMETER TaskPath
    The path where the task will be stored. If no value is supplied, it will default to "\Custom".

    .PARAMETER Force
    If this switch is present, the task will be replaced if it already exists.

    .EXAMPLE
    Register-ComputerUsageTask -LogPath "D:\Logs" -LogFile "CustomLog.log" -TaskPath "\Custom" -Force

    Registers the computer usage task with a custom log file and task path, replacing the task if it already exists.

    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogPath = "C:\Temp",

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogFile = "ComputerUsage_$env:COMPUTERNAME.log",

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TaskPath,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Force
    )

    $XMLTaskPaths = Get-ChildItem -Path "$Script:DataPath" -Filter *.xml | Select-Object -ExpandProperty FullName
    $XMLTaskPaths | ForEach-Object {
        $XMLTaskRaw = Get-Content -Path $_ -Raw
        [xml]$TaskXML = Get-Content -Path $_
        $TaskSplit = $TaskXML.Task.RegistrationInfo.URI -split '(?<=\\)(?=[^\\]*$)'

        if (! $TaskPath) {
            $TaskPath = $TaskSplit[0]
        }
        $TaskName = $TaskSplit[1]

        $XMLTaskRaw = $XMLTaskRaw.Replace('__LogPath__', "$LogPath")
        $XMLTaskRaw = $XMLTaskRaw.Replace('__LogFile__', "$LogFile")

        if (Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction SilentlyContinue) {
            if ($Force) {
            Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false
            Register-ScheduledTask -Xml $XMLTaskRaw -TaskName $TaskName -TaskPath $TaskPath
            Write-Output "Task replaced: $TaskPath\$TaskName"
            } else {
            Write-Warning "Task already exists: $TaskPath\$TaskName (Use -Force to replace)"
            }
        } else {
            Register-ScheduledTask -Xml $XMLTaskRaw -TaskName $TaskName -TaskPath $TaskPath
            Write-Verbose "Task created: $TaskPath\$TaskName"
        }
    }
}