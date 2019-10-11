Configuration DC {
    
    param             
    (             
        [Parameter(Mandatory)]             
        [string]$domainname,             
        [Parameter(Mandatory)]            
        [pscredential]$safemodeCred,
        [Parameter(Mandatory)]            
        [pscredential]$domainCred

    )    

    Import-DscResource -ModuleName xActiveDirectory  
    Import-DscResource -ModuleName xAdcsDeployment 

    Node 'localhost' {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
            ConfigurationMode  = 'ApplyOnly'
            ActionAfterReboot  = 'ContinueConfiguration'
        }

        WindowsFeature ADDSInstall {             
            Ensure = "Present"             
            Name   = "AD-Domain-Services"             
        }            
            
        WindowsFeature ADDSTools {             
            Ensure = "Present"             
            Name   = "RSAT-ADDS"             
        }  

        xADDomain FirstDS {             
            DomainName                    = $domainname             
            DomainAdministratorCredential = $domainCred             
            SafemodeAdministratorPassword = $safemodeCred          
            DatabasePath                  = 'C:\NTDS'            
            LogPath                       = 'C:\NTDS'            
            DependsOn                     = "[WindowsFeature]ADDSInstall"           
        } 

        WindowsFeature ADCS-Cert-Authority {
            Ensure    = 'Present'
            Name      = 'ADCS-Cert-Authority'
            DependsOn = "[xADDomain]FirstDS"
        }

        xADCSCertificationAuthority ADCS {
            Ensure     = 'Present'
            Credential = $domainCred
            CAType     = 'EnterpriseRootCA'
            DependsOn  = '[WindowsFeature]ADCS-Cert-Authority'              
        }
        WindowsFeature ADCS-Web-Enrollment {
            Ensure    = 'Present'
            Name      = 'ADCS-Web-Enrollment'

            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }
        xADCSWebEnrollment CertSrv {
            Ensure           = 'Present'
            Credential       = $domainCred
            IsSingleInstance = "yes"
            DependsOn        = '[WindowsFeature]ADCS-Web-Enrollment', '[xADCSCertificationAuthority]ADCS'
        } 


    
        

    }
}


