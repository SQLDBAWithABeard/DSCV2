
$ScriptBlock = {
$Drive = Mount-diskimage c:\mssql\SQLServer2016RC0-x64-ENU.iso|Get-Disk |Get-Volume|Get-Partition
cd "$($Drive)" 
.\Setup.exe /ACTION=CompleteImage /Q /IACCEPTSQLSERVERLICENSETERMS /SQLSYSADMINACCOUNTS="THEBEARD\Rob"  /INSTANCEID="MSSQLSERVER" /INSTANCENAME="MSSQLSERVER"
}

$session = New-PSSession -ComputerName SQL2016N2 -Credential (Import-Clixml -Path D:\Creds\THEBEARDRob.xml)
Copy-Item D:\ISOs\SQLServer2016RC0-x64-ENU.iso  c:\mssql -ToSession $session
Invoke-Command -Session $session -ScriptBlock $ScriptBlock