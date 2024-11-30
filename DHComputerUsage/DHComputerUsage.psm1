$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach ($Script in @($Public + $Private)) {
    try {
        . $Script.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($Script.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.Basename

$Script:DataPath = "$PSScriptRoot\Data"