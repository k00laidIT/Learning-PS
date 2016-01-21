$file = Read-Host "What is the full path of the file you want to copy?"
$loc= Read-Host "Where is your CSV file?"
$import = Import-Csv -Path $loc -Header "username","computer"
foreach($row in $import) {    
    $path = "\\"+$row.computer+"\c$\users\"+$row.username+"\Desktop"
    Write-Host $path 
    $Test = Test-Path $path
    If($Test -eq $true) {
        Copy-Item $file $path
    }
}
