#Open-Exchange
#Prompts for servername and credentials and then gives you a remote Exchange Shell connection

$Server = Read-Host -Prompt "What's the server name"
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$Server/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session