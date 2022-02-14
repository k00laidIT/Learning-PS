#Get-DNSSettings.ps1
$searchbase = "dc=domain,dc=site"
$servers = Get-ADComputer -SearchBase $searchbase -Filter 'operatingSystem -like "Windows Server*"' -Properties name, dnshostname, ipv4address
$dnsoutput = $servers | Foreach-Object {
    $serverName = $_.name
    $serverIP = $_.ipv4address

    if ($serverIP -ne $null) {
        $serverprefix = $serverIP.substring(0,6)
        $goodDNS = "$serverprefix.1.1 $serverprefix.1.2"
        if (Test-Connection -computername $serverName -Quiet -Count 1) {
            $serverOutput = Get-DnsClientServerAddress -CimSession $serverName -AddressFamily IPv4 | Where-Object -Filter {$_.InterfaceAlias -like "Ethernet*"}
            
            #$serverOutput = Invoke-Command -ComputerName $serverName -ScriptBlock {
            #Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object -Filter {$_.InterfaceAlias -eq "Ethernet0"}
            #}
            $serverAddresses = $serverOutput.ServerAddresses -join ': '
            if ($serverAddress -eq $goodDNS) {
                $isbad = "Yes"
            }
            else {
                $isbad = "No"
            }
        }
    }
    $props = @{ 'ServerName' = $serverName;          
                'DNSUpdateReq' = $isbad;                          
                'ServerAddresses' = $serverAddresses               
            }

        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
}

$dnsoutput #| Export-CSV -Path "DNSOutput.csv"
