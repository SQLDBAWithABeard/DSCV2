## Pull Server setup

Enter-pssesion pullserver
Add-WindowsFeature DSC-Service
$Registrationkey = "8f4c3893-50b2-4f13-8c20-236db525a01f"
$Registrationkey 
configuration PullServer
{ 
    param  
    ( 
            [string[]]$NodeName = 'localhost', 

            [ValidateNotNullOrEmpty()] 
            [string] $certificateThumbPrint,

            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string] $RegistrationKey 
     ) 


     Import-DSCResource -ModuleName PSDesiredStateConfiguration -ModuleVersion '1.1'
     Import-DscResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion '3.9.0.0'

     Node $NodeName 
     { 
         WindowsFeature DSCServiceFeature 
         { 
             Ensure = "Present" 
             Name   = "DSC-Service"             
         } 


         xDscWebService PSDSCPullServer 
         { 
             Ensure                  = "Present" 
             EndpointName            = "PSDSCPullServer" 
             Port                    = 8080 
             PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer" 
             CertificateThumbPrint   = "AllowUnencryptedTraffic" ## $certificateThumbPrint          
             ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules" 
             ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"             
             State                   = "Started" 
             DependsOn               = "[WindowsFeature]DSCServiceFeature"                         
         } 

        File RegistrationKeyFile
        {
            Ensure          ='Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
            DependsOn       = "[WindowsFeature]DSCServiceFeature" 
        }
    }
}

Pullserver -RegistrationKey $Registrationkey -OutputPath c:\Configs\PullServer
Start-DscConfiguration C:\Configs\PullServer -Verbose -wait -Force