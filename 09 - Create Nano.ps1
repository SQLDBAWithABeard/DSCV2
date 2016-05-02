## Create nano server

# Copy module
Copy-Item D:\InstallShare\Server2016TP5\NanoServer\NanoServerImageGenerator -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse
#Import module
Import-Module NanoServerImageGenerator
# look at commands
Get-Command -Module NanoServerImageGenerator
Get-Help New-NanoServerImage -ShowWindow 
get-help New-NanoServerImage -Examples

$Nano = 'Nano'
$IP = '10.1.0.' 
$x = 5
while ($x -gt 1)
{
    # create Nano server image VHDX
    $Nano = $Nano + 1
    $Ip = $IP + 1
New-NanoServerImage -MediaPath D:\InstallShare\Server2016TP5 -DeploymentType Guest -Edition Standard -TargetPath D:\VMs\Nano\$Nano.vhdx `
-ComputerName $Nano -AdministratorPassword (Import-Clixml D:\creds\LocalAdmin.xml).Password -EnableRemoteManagementPort  `
 -Ipv4Address $IP -Ipv4SubnetMask '255.0.0.0' -Ipv4Gateway '10.0.0.1'  -Ipv4Dns '10.0.0.1' -InterfaceNameOrIndex Ethernet `
 -Packages Microsoft-NanoServer-DSC-Package

# Create Hyper-V VM
New-VM -Name $Nano -VHDPath D:\VMs\Nano\$Nano.vhdx -SwitchName (Get-VMSwitch).Name -MemoryStartupBytes 512mb -Generation 2

# Start the VM
Start-VM -Name $Nano
}


$cred = New-Object System.Management.Automation.PSCredential "$Nano\Administrator", (Import-Clixml D:\creds\LocalAdmin.xml).Password
# Connect to the VM
Enter-PSSession -VMName $Nano -Credential $cred 

