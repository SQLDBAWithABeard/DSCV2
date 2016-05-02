## Set up 
$SQLServers = 'SQL2016N1','SQL2016N2','SQL2016N3'
[guid]$Registrationkey = "8f4c3893-50b2-4f13-8c20-236db525a01f"
$pullserver = 'PullServer'
$ConfigPath = 'd:\Configs\SQLLCM'
foreach($SQLServer in $SQLServers)
{
PullClientConfigIDSQL -Registrationkey $Registrationkey -ComputerName $SQLServer -PullServer $pullserver -OutputPath $ConfigPath -Verbose
$Cimsession = New-CimSession -ComputerName $SQLServer -Credential (Import-Clixml D:\Creds\THEBEARDRob.xml)
Set-DscLocalConfigurationManager D:\Configs\SQLLCM -CimSession $Cimsession -Verbose 
}