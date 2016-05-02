<#
.Synopsis
   Creates a new Hyper-V VM using a copy of a sysprepped VHDX
.DESCRIPTION
   Creates a new Hyper-V VM using a copy of a sysprepped VHDX creates an unattend.xml file and starts the VM
.EXAMPLE
   This command will create a VM called SQL2016 using the sysprepped vhdx at D:\VMs\Base\Server2016TP5.vhdx
   store the new vhdx at D:\VMs with a connection to the VM Switch TheBeardInternal and ask for local admin credentials with 24GB RAM
     Create-VMFromBase -BaseVHDBaseVHDX D:\VMs\Base\Server2016TP5.vhdx -DestVHDxBase D:\vms\ -VMName SQL2016 -ProductKey XXXX-XXXX-XXXX-XXXX-XXXX -LocalAdminCreds (Get-Credential) -VMSwitch TheBeardInternal -RAM 24GB
.NOTES
   REQUIRES NewUnattendXml SetUnattendXm ResolvePathEx to be loaded first - Visit https://github.com/VirtualEngine/Lability
   and search for them and load them
   
   THANK YOU Iain brighton @iainbrighton
#>

function Create-VMFromBase
{
    [CmdletBinding(SupportsShouldProcess=$true, 
                  PositionalBinding=$false
                 )]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({Test-Path $_ })]
        [string]$BaseVHDBaseVHDX = 'D:\vms\Base\Server2016TP5.vhdx',
        
        # Param3 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({Test-Path $_ })]
        [String]$DestVHDxBase = 'D:\Vms\', # trailing slash 

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({(!(Get-VM -Name $_))})]
        [String]$VMName,

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^[A-Z0-9]{5,5}-[A-Z0-9]{5,5}-[A-Z0-9]{5,5}-[A-Z0-9]{5,5}-[A-Z0-9]{5,5}$')]
        $ProductKey = '6XBNX-4JQGW-QX6QG-74P76-72V67',

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$LocalAdminCreds = (Import-Clixml D:\creds\LocalAdmin.xml),
        
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({(Get-VMSwitch -Name $_)})]       
        [string]$VMSwitch,
        
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [long]$RAM = 2GB, # Number and unit eg 2GB        
        
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $Timezone = 'GMT Standard Time'
    )

    # Check for NewUnattendXMl, SetUnattendXML and ResolvePathEx from 

    if( ((Get-Command NewUnattendXml -ErrorAction SilentlyContinue) -or (Get-Command SetUnattendXml -ErrorAction SilentlyContinue) -or (Get-Command ResolvePathEx -ErrorAction SilentlyContinue)) -eq $false)
    {
    Write-Warning 'You do not have all the required functions - Visit https://github.com/VirtualEngine/Lability and search for  NewUnattendXml SetUnattendXm ResolvePathEx and load them first' 
    break
    }

$DestVMVHDxPath = $DestVHDxBase + $VMName +'.vhdx'

Copy-Item $BaseVHDBaseVHDX -Destination $DestVMVHDxPath  
Set-ItemProperty -Path $DestVMVHDxPath -Name isreadonly -Value $false

$MountedVHD = (Mount-VHD -Path $DestVMVHDxPath  -Passthru |get-disk |Get-Partition | Get-Volume).DriveLetter 
$UnattendPath = $MountedVHD + ':\\Windows\System32\Sysprep\Unattend.xml'

       $UnAttendXMLParams = @{
        Path = $UnattendPath;
        Credential = $LocalAdminCreds; # Local Admin
        ComputerName = $VMName;
        ProductKey = $ProductKey; 
        InputLocale = 'en-GB';
        SystemLocale = 'en-GB';
        UserLocale = 'en-GB';
        UILanguage = 'en-GB';
        Timezone = $Timezone ;
        RegisteredOwner = 'Rob';
        RegisteredOrganization = 'The Beard';
        }

  SetUnattendXml @UnattendXmlParams;

  Dismount-VHD -Path $DestVMVHDxPath

  New-VM -Name $VMName -MemoryStartupBytes $RAM -VHDPath $DestVMVHDxPath -SwitchName $VMSwitch  -BootDevice VHD -Generation 2
  Start-VM $VMName
}