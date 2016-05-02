## Build the lab part one

 Create-VMFromBase -BaseVHDBaseVHDX D:\VMs\Base\Server2016TP5.vhdx -DestVHDxBase D:\vms\ -VMName PullServer -ProductKey 6XBNX-4JQGW-QX6QG-74P76-72V67 -LocalAdminCreds (Import-Clixml D:\Creds\LocalAdmin.xml) -VMSwitch (Get-VMSwitch).Name -RAM 2GB
 Create-VMFromBase -BaseVHDBaseVHDX D:\VMs\Base\Server2016TP5.vhdx -DestVHDxBase D:\vms\ -VMName SQL2016 -ProductKey 6XBNX-4JQGW-QX6QG-74P76-72V67 -LocalAdminCreds (Import-Clixml D:\Creds\LocalAdmin.xml) -VMSwitch (Get-VMSwitch).Name -RAM 4GB


 ## Set IPAddress and connect Pull Server to the domain

 $DomainCreds = (Import-Clixml D:\Creds\THEBEARDRob.xml)
 $ScriptBlock = {
$adapter = Get-NetAdapter -name Ethernet
$adapter | Remove-NetIPAddress -Confirm:$false
$adapter | Remove-NetRoute -Confirm:$false
$adapter | New-NetIPAddress -IPAddress 10.0.0.2 -AddressFamily IPv4 -PrefixLength 8 -DefaultGateway 10.0.0.1
$adapter | Set-DnsClientServerAddress -ServerAddresses 10.0.0.1
sleep -Seconds 10
Add-Computer -DomainName 'THEBEARD.local' -Credential $Using:DomainCreds
 }
 Invoke-Command -VMName PullServer -ScriptBlock $ScriptBlock -Credential (Import-Clixml D:\Creds\LocalAdmin.xml)
 Restart-VM PullServer -Confirm:$false -Force

 ## Set gateway and dns adn add SQL2016 to the domain

 
 $DomainCreds = (Import-Clixml D:\Creds\THEBEARDRob.xml)
 $ScriptBlock = {
$adapter = Get-NetAdapter -name Ethernet
$adapter | Remove-NetIPAddress -Confirm:$false
$adapter | Remove-NetRoute -Confirm:$false
$adapter | New-NetIPAddress -IPAddress 10.0.10.1 -AddressFamily IPv4 -PrefixLength 8 -DefaultGateway 10.0.0.1
$adapter | Set-DnsClientServerAddress -ServerAddresses 10.0.0.1
New-NetFirewallRule –DisplayName “Allow Ping” –Direction Inbound –Action Allow –Protocol icmpv4 –Enabled True
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
sleep -Seconds 10
Add-Computer -DomainName 'THEBEARD.local' -Credential $Using:DomainCreds
 }
 Invoke-Command -VMName SQL2016 -ScriptBlock $ScriptBlock -Credential (Import-Clixml D:\Creds\LocalAdmin.xml)
 Restart-VM SQL2016 -Confirm:$false -Force

 ## Then install SQL Server 2016 in image preperation mode and sysprep
