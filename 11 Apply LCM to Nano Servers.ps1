## Set up 
$NanoServers = Get-Vm
[guid]$Registrationkey = "8f4c3893-50b2-4f13-8c20-236db525a01f"
$pullserver = 'PullServer'
$ConfigPath = 'd:\Configs\SQLLCM'
foreach($NanoServer in $NanoServers)
{
PullClientConfigIDSQL -Registrationkey $Registrationkey -ComputerName $NanoServer -PullServer $pullserver -OutputPath $ConfigPath -Verbose
$Cimsession = New-CimSession -ComputerName $NanoServer -Credential (Import-Clixml D:\Creds\THEBEARDRob.xml)
Set-DscLocalConfigurationManager D:\Configs\SQLLCM -CimSession $Cimsession -Verbose 
}