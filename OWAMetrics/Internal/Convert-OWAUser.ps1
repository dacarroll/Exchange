function Convert-OWAUser {

    [cmdletbinding()]
    param (
        [Parameter(
           Mandatory = $true
        )]
        [pscustomobject]$OWAConnection,

        [String]$LogOutputPath,

        [String]$LogName,

        [switch]$export
    )
    Begin {
        if ($PSBoundParameters.ContainsKey('LogOutPutPath') -and $PSBoundParameters.ContainsKey('LogName')) {
            $LogPath = Join-Path $LogOutputPath $LogName
        }
    }

    Process {
        $user = $OWAConnection.User
        if ($OWAConnection.User -match "\d@mil") {
            Try {
                $userAD = (Get-ADUser -Filter { userprincipalname -eq $user }).SamAccountName
                if (!$userAD) { Throw [System.Exception]::new('FindOWAUser') }
                else {
                    $obj = [pscustomobject]@{
                        Date = $OWAConnection.Date
                        SamAccountName = $userAD
                    }
                    if ($PSBoundParameters.ContainsKey('export')) {
                        $obj | Export-Csv -Path $LogPath -NoTypeInformation -Append
                    } else { $obj }
                }
            }
            Catch {
                Write-Warning "Can't translate account for $($OWAConnection.User)"
                $obj = [pscustomobject]@{
                    Date = $OWAConnection.Date
                    SamAccountName = $OWAConnection.User
                }
                if ($PSBoundParameters.ContainsKey('export')) {
                        $obj | Export-Csv -Path $LogPath -NoTypeInformation -Append
                    } else { $obj }
            }
        }
        else {
            $obj = [pscustomobject]@{
                Date = $OWAConnection.Date
                SamAccountName = $OWAConnection.User
            }
            if ($PSBoundParameters.ContainsKey('export')) {
                        $obj | Export-Csv -Path $LogPath -NoTypeInformation -Append
                    } else { $obj }
        }
    }
}