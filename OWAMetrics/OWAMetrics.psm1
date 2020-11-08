$FunctionFolders = "Public", "Internal"
foreach ($Folder in $FunctionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if (Test-Path -Path $folderPath) {
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
        Foreach ($function in $functions) {
            . $function.FullName
        }
    }
}