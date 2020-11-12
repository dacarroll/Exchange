function Get-OWALog {

    [cmdletbinding()]
	Param (
        [DateTime]$Date,

        [String]$LogOutputPath
    ) 

    Begin {
        $jsonConfig = Get-ExchangeIISLog
        $csRefererFilter = $jsonConfig.csReferer.ToString()
        $csUserFilter = $jsonConfig.csUserName.ToString()
        $ExchangeServers = $jsonConfig.Exchange
    }

    Process {
        $StartTime = [DateTime]::Now
        Write-Verbose "Getting all files from Exchange Server"
        $AllFiles = foreach ($Server in $ExchangeServers) {
            $Path = Join-Path $Server.Server $Server.IISPath
            Get-ChildItem -Path $Path
        }
        Write-Verbose "Filtering files to specified date"
        $AllFiles = $AllFiles | Where-Object LastWriteTime -GE $Date
        foreach ($File in $AllFiles) {
            Write-Verbose "Start Parse: $($File.Fullname)"
            $OWA = Get-OWAIISLogParse -Path $File.FullName 

            Write-Verbose "Build array and remove duplicates"
            $OWAConns = [System.Collections.ArrayList]::new()
            foreach ($connection in $OWA) {
                if ( ($connection.csReferer -like "*$csRefererFilter*") -and
                     ($connection.'cs-username' -ne "-")
                   ) {   
                         $obj = [pscustomobject]@{
                            Date = $connection.date
                            User = $connection.'cs-username'
                            Type = 'External'
                         }
                         $null = $OWAConns.Add($obj)
                     }

                elseif ( ($connection.csReferer -NotLike "*$csRefererFilter*") -and 
                         ($connection.'cs-username'-NotLike "$csUserFilter*") -and 
                         ($connection.'cs-username' -ne "-")
                       ) {   
                             $obj = [pscustomobject]@{
                                Date = $connection.date
                                User = $connection.'cs-username'
                                Type = 'Internal'
                             }
                             $null = $OWAConns.Add($obj)
                         }
            }
            $UniqueOWAConns = $OWAConns | Select-Object Date, User, Type -Unique
            Write-Verbose "Array Build Complete: Total Size:($($UniqueOWAConns.Count))"
            if ($PSBoundParameters.ContainsKey('LogOutputPath')) {
                Write-Verbose "Exporting results to csv"
                $InternalLogName = [datetime]::Now.ToString('dd-MMM-yy') + '_Internal.csv'
                $ExternalLogName = [datetime]::Now.ToString('dd-MMM-yy') + '_External.csv'
                foreach ($UniqueConn in $UniqueOWAConns) {
                    if ($UniqueConn.Type -eq 'Internal') {
                        $obj = @{
                            OWAConnection = $UniqueConn
                            LogOutputPath = $LogOutputPath
                            LogName       = $InternalLogName
                        }
                        Convert-OWAUser @obj -export
                    }
                    elseif ($UniqueConn.Type -eq 'External') {
                        $obj = @{
                            OWAConnection = $UniqueConn
                            LogOutputPath = $LogOutputPath
                            LogName       = $ExternalLogName
                        }
                        Convert-OWAUser @obj -export
                    }
                }
                Write-Verbose "Exporting to csv complete!"
            } else {
                Write-Verbose "Converting UPN to SamAccountName"
                foreach ($UniqueConn in $UniqueOWAConns) {
                    Convert-OWAUser -OWAConnection $UniqueConn
                }
                Write-Verbose "Conversion to SamAccountName Complete"
            }            
        }
    $EndTime = [DateTime]::Now
    $Runtime = $EndTime - $StartTime
    Write-Verbose "Get-OWALogs complete, RunTime = $($EndTime - $StartTime)" -Verbose
    }

    End {}
}