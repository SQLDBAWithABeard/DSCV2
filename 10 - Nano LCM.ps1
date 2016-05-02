[DSCLocalConfigurationManager()]
configuration PullClientConfigIDNano
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
            ServerURL = 'http://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
            ConfigurationNames = @('NanoConfig')
            AllowUnSecureConnection = $True
        }
   
        ResourceRepositoryWeb PullServerResourceSrv
        {
            ServerURL = 'http://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
            AllowUnSecureConnection = $True
        }

        ReportServerWeb PullServerReportSrv
        {
            ServerURL = 'http://' + $PullServer + ':8080/PSDSCPullServer.svc'
            RegistrationKey = $Registrationkey
            AllowUnSecureConnection = $True
        }
    }
}

## If on localhost uncomment this line

# PullClientConfigIDNano -Registrationkey 8f4c3893-50b2-4f13-8c20-236db525a01f -ComputerName localhost -PullServer PullServer -OutputPath c:\temp\NanoLCM -Verbose
# Set-DscLocalConfigurationManager -Path c:\temp\NanoLCM