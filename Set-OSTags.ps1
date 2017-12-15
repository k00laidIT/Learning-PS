Import-Module VMware.PowerCLI
$vcenter = "labvcsa1.lab.local"
$TagCategory = "OS"
$WinTag = "Windows_Servers"
$LinuxTag = "Linux_Servers"
Connect-VIServer $vcenter

#Sanity Checks
if(!(Get-TagCategory -Name $TagCategory)) {
    New-TagCategory -Name $TagCategory -EntityType "VirtualMachine"
    Write-Host "New tag category $TagCategory created"
}
if(!(Get-Tag -Name $WinTag)) {
    New-Tag -Name $WinTag -Category $TagCategory
    Write-Host "New tag $WinTag created"
}
if(!(Get-Tag -Name $LinuxTag)) {
    New-Tag -Name $LinuxTag -Category $TagCategory
    Write-Host "New tag $LinuxTag created"
}

#Assign tags to all VMs in infrastructure based on OS family
foreach($vm in (Get-VM)){
    if($vm.Guest.GuestFamily -like "windowsGuest") {
        New-TagAssignment -Entity $vm -Tag $WinTag   
    }    
    elseif($vm.Guest.GuestFamily -like "linuxGuest") {
        New-TagAssignment -Entity $vm -Tag $LinuxTag
    }
}
