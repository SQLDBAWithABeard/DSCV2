## Added or removed to change checksum                
Configuration SQLConfig
{

Node ('localhost')
    {
        WindowsFeature NET-Framework-Core                    
        {
            Ensure = "Present"
            Name = "NET-Framework-Core"
            Source = "\\BeardNUC\InstallShare\Server2016TP5\sources\sxs"
        }
    }
}

if(!(Test-Path D:\Configs\SQLConfig))
{
New-Item D:\Configs\SQLConfig -ItemType Directory
}
SQLConfig -OutputPath D:\Configs\SQLConfig -Verbose

Copy-Item D:\Configs\SQLConfig\localhost.mof -Destination '\\PullServer\C$\Program Files\WindowsPowerShell\DscService\Configuration\SQLConfig.mof'
New-DscChecksum '\\PullServer\C$\Program Files\WindowsPowerShell\DscService\Configuration\SQLConfig.mof'