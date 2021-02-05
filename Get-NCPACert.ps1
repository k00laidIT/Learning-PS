function Get-NCPACert {
  <#
.Synopsis
  Simplified Script to use Posh-Acme to Grab a DNS Challenge Let's Encrypt certificate using the Name Cheap Plugin
.Notes
   Version: 0.5
   Author: Jim Jones
   Modified Date: 02-11-2020
.EXAMPLE
  Get-NCPACert -ncusername myusername -nckey <namecheap API key> - hostname example.domain.com
#>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$ncusername,
    [Parameter(Mandatory)]
    [string]$ncKey,
    [Parameter(Mandatory)]
    [string]$hostname
​
  )
​
  begin {
    if (!(Get-Module -Name Posh-ACME -ErrorAction SilentlyContinue)) {
      if (!(Import-Module -Name Posh-ACME -ErrorAction SilentlyContinue)) {
        Install-Module -Name Posh-ACME -Scope CurrentUser
      }
      Import-Module -Name Posh-ACME -ErrorAction SilentlyContinue
    }
  }
​
  process {
    $ncParams = @{NCUsername = $ncusername; NCApiKey = $ncKey }
    New-PACertificate $hostname -DnsPlugin Namecheap -PluginArgs $ncParams -Install
  }
​
  end {
​
  }
}