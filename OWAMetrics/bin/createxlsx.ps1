param ($Path)

$csvs = Get-ChildItem -Path $Path | where name -Like "*.csv" | select fullname, name | Sort-Object -Property FullName -Descending

$xl = New-Object -ComObject excel.application
$xl.Visible = $true
$xl.DisplayAlerts = $false
$Workbook2 = $xl.Workbooks.Add()

foreach ($csv in $csvs) {
    Write-Host "Copying worksheet $($csv.Name)"
    $Workbook = $xl.Workbooks.open($csv.FullName)
    $Worksheet = $Workbook.WorkSheets.item(1)
    

    $worksheet2 = $Workbook2.Worksheets.Add()
    $worksheet2.Name = ($csv.name).Replace(".csv","")

    $range = $worksheet.Range("A1:B1048576")
    $null = $range.Copy()
    $range2 = $worksheet2.Range('A1:A1')
    $worksheet2.Paste($range2)

    $Workbook.Close()

    Remove-Variable worksheet
    Remove-Variable Workbook
}
