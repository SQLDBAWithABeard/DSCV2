## Added or removed to change checksum                
Configuration NanoConfig
{

Node ('localhost')
    {
        File Share {
        DestinationPath = 'C:\TheBeard'
        Ensure = 'Present'
        Type = 'Directory'
        }
    }
}

if(!(Test-Path D:\Configs\NanoConfig))
{
New-Item D:\Configs\NanoConfig -ItemType Directory
}
NanoConfig -OutputPath D:\Configs\NanoConfig -Verbose

Copy-Item D:\Configs\NanoConfig\localhost.mof -Destination '\\PullServer\C$\Program Files\WindowsPowerShell\DscService\Configuration\NanoConfig.mof'
New-DscChecksum '\\PullServer\C$\Program Files\WindowsPowerShell\DscService\Configuration\NanoConfig.mof'