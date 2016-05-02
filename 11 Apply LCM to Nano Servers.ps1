## Set up 
$NanoServers = (Get-Vm -name Nano*).Name
[guid]$Registrationkey = "8f4c3893-50b2-4f13-8c20-236db525a01f"
$pullserver = 'PullServer'
$OutputPath = 'd:\Configs\NanoLCM'
$Credential = (Import-Clixml D:\Creds\LocalAdmin.xml)

foreach($NanoServer in $NanoServers)
{
Invoke-Command -VMName $NanoServer -FilePath 'D:\Powershell Scripts\Hyper-v\Beard NUC\10 - Nano LCM.ps1' -Credential $Credential
}