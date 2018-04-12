 $gateway = "myHonoluluServerName"
 $servers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*")} -Properties *
 Foreach ($server in $servers) {
	$gatewayObject = Get-ADComputer -Identity $gateway
	$nodeObject = Get-ADComputer -Identity $server
	Set-ADComputer -Identity $nodeObject -PrincipalsAllowedToDelegateToAccount $gatewayObject
}