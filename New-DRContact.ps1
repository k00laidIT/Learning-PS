#New-DRContact.ps1
#Allows for the creation of Exchange 2010-2016 Mail Contacts for both a mobile phone and a personal e-mail address
#If you wish these addresses to be listed in the GAL comment the Set-MailContact lines

$OU = Read-Host -Prompt "OU to put the contact in (format domain/staff/contacts)"
$FirstName = Read-Host -Prompt "What is the user's first name"
$LastName = Read-Host -Prompt "What is the user's last name"
$Mobile = Read-Host -Prompt "What is the mobile number e-mail address (Common Domains- txt.att.net, vtext.com, pcs.ntelos.net, sprintpcs.com)"
$Personal = Read-Host -Prompt "What is the user's personal e-mail address"

if ($Mobile) {
    $MobileCName = $FirstName + " " + $LastName + " Mobile"
    $MCAlias =$FirstName.ToLower().Substring(0,1) + $LastName.ToLower() + "mobile"
    New-MailContact -Name $MobileCName -Alias $MCAlias -ExternalEmailAddress $Mobile -OrganizationalUnit $OU
    Set-MailContact $MCAlias -HiddenFromAddressListsEnabled $true    
}

if ($Personal) {
    $PersonalCName = $FirstName + " " + $LastName + " Personal"
    $PCAlias =$FirstName.ToLower().Substring(0,1) + $LastName.ToLower() + "personal"
    New-MailContact -Name $PersonalCName -Alias $PCAlias -ExternalEmailAddress $Personal -OrganizationalUnit $OU
    Set-MailContact $PCAlias -HiddenFromAddressListsEnabled $true    
}