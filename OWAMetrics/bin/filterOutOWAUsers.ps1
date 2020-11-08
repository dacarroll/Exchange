$users = Get-ADUser -Filter * -Properties "Homemdb", "enabled", "EmployeeID"


$UserFilterHomemdb = $users | where {$_.homemdb -ne $null}
$UsersFiltered = $UserFilterHomemdb | where { $_.enabled -ne $false }
$UsersFiltered = $UsersFiltered | where { $_.EmployeeID -ne $null }

$users = $UsersFiltered | Get-ADUser -Properties displayname, userprincipalname, samaccountname
$users = $users | where { $_.UserPrincipalName -match "\d@mil" }

$OWAUsers = (Import-Csv -Path H:\OWALogs\UniqueUsers.csv).samaccountname

$MigrateUsers = $users | where { $_.samaccountname -notin $OWAUsers }