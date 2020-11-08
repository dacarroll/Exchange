function Get-OWAIISLogParse {

    [cmdletbinding()]
    param (
        [string]$Path,

        [switch]$ExternalOWA
    )

	# Get the contents of the file, excluding the first three lines.
    if ($PSBoundParameters.ContainsKey('ExternalOWA')) {
        $fileContents = Get-Content $Path | Where-Object { ($_ -notLike "#[D,S-V]*") -and ($_ -like "*owa-sts*") }
    } 
    else {
	    $fileContents = Get-Content $Path | Where-Object { ($_ -notLike "#[D,S-V]*") -and ($_ -like "*/owa/*") }
    }
    $columns = (((Get-Content -First 4 -Path $file.FullName)[3].TrimEnd()) -replace "#Fields: ", "" -replace "\(","" -replace "\)","").Split(" ")

	# Loop through rows in the log file.
	foreach ($row in $fileContents)
	{
		if(!$row)
		{
			continue
		}
        $rowSplit = $row.Split(" ")
        [pscustomobject]@{
            $columns[0] = $rowSplit[0]
            $columns[1] = $rowSplit[1]
            $columns[2] = $rowSplit[2]
            $columns[3] = $rowSplit[3]
            $columns[4] = $rowSplit[4]
            $columns[5] = $rowSplit[5]
            $columns[6] = $rowSplit[6]
            $columns[7] = $rowSplit[7]
            $columns[8] = $rowSplit[8]
            $columns[9] = $rowSplit[9]
            $columns[10] = $rowSplit[10]
            $columns[11] = $rowSplit[11]
            $columns[12] = $rowSplit[12]
            $columns[13] = $rowSplit[13]
            $columns[14] = $rowSplit[14]
        }
	}
    Write-Verbose "Parse Complete: $($file.name)"
}