# Client Computer Name
$workstation = Read-Host -Prompt 'Input the computer name'


# WSUS Connection Parameters:
[String]$updateServer = "SERVERFQDN"
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 80

# Load .NET assembly
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
 
# Connect to WSUS Server
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($updateServer,$useSecureConnection,$portNumber)
 
# Perform Cleanup
$client = $wsus.GetComputerTargetByName($workstation)
$client.Delete()
