#   Clean-Printers.ps1
#   Desc: Given that printers are assigned by group name with a specific prefix, script will dump all printers shared by
#       the server in the 'oldprintserver' variable, then enumerate groups looking for those with the prefix, and add
#       any printers with the same group prefix. Handy for print server migrations and printer share changes.

$oldprintserver = "\\MYOLDSERVER"
$newprintserver = "\\MYNEWSERVER"
$groupprefix = "prnt"
Get-Printer | Where-Object {$_.name -like $oldprintserver + '*'} | select name | Remove-Printer
$usergroups = Get-ADPrincipalGroupMembership $env:UserName | Where-Object {$_.name -like $groupprefix + '*'} | select name
foreach ($group in $usergroups) {    
    $printers = $group.name.TrimStart($groupprefix)    
    foreach ($printer in $printers) {
        $printerName = $newprintserver + '\' + $printer
        Add-Printer -ConnectionName $printerName
    }
}