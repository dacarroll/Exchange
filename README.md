# OWA Metrics

This module is for gathering Exchange IIS logs and parsing the results.

Guide:

```PowerShell
#Parse Exchange IIS logs and output to log
$Date = [DateTime]::Now.AddDays(-1)
Get-OWALogs -Date $Date -LogOutputPath C:\LogOutput

#Parse Exchange IIS logs and output to host
$Date = [DateTime]::Now.AddDays(-1)
Get-OWALogs -Date $Date
```

Performance:

```PowerShell
VERBOSE: Exporting results to csv
VERBOSE: Exporting to csv complete!
VERBOSE: Get-OWALogs complete, RunTime = 00:30:00.6168589

#LogFiles Parsed: 110
#Rows of text: 10,398,113
```
