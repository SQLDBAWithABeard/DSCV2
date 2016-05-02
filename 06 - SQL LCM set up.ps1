[DSCLocalConfigurationManager()]
configuration PullClientConfigIDSQL
{
param
(
[guid] $Registrationkey,
[Parameter(Mandatory=$true)]
[string[]]$ComputerName,
[Parameter(Mandatory=$true)]
[string]$PullServer
)
    Node $ComputerName
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryWeb PullServer
        {
            ServerURL = 'https://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
            ConfigurationNames = @('SQLConfig')
        }
       
        ResourceRepositoryWeb PullServerResourceSrv
        {
            ServerURL = 'https://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
        }

        ReportServerWeb PullServerReportSrv
        {
            ServerURL = 'https://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
            AllowUnsecureConnection = $True
        }
    }
}
## If on localhost uncomment this line

## PullClientConfigIDSQL -Registrationkey 8f4c3893-50b2-4f13-8c20-236db525a01f -ComputerName localhost -PullServer PullServer -OutputPath c:\temp\SQLLCM -Verbose