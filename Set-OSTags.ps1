<#
.Synopsis
  Assigns a general tag for Operating System to all VMs on a given vCenter based on the Guest.GuestFamily attribute of the VMs. Reason would be for credential selection for backup applications
.Notes
   Version: 0.5
   Author: Jim Jones
   Modified Date: 3/5/2021   
.EXAMPLE
  .\Set-OSTags.ps1 -vCenter = 'labvcsa1.lab.local'
#>
[CmdletBinding()]
Param (
    [string]$vCenter = "labvcsa1.lab.local"
)

Import-Module VMware.PowerCLI
$TagCategory = "OS"
$WinTag = "Windows"
$LinuxTag = "Linux"
Connect-VIServer $vCenter

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
