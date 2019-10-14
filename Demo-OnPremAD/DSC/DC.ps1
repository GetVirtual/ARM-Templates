Configuration DC {
    
    param             
    (             
        [Parameter(Mandatory)]             
        [string]$domainname,             
        [Parameter(Mandatory)]            
        [pscredential]$safemodeCred,
        [Parameter(Mandatory)]            
        [pscredential]$domainCred,
        [Parameter(Mandatory)]            
        [string]$CARootName

    )    

    Import-DscResource -ModuleName xActiveDirectory  
    Import-DscResource -ModuleName xAdcsDeployment 
    Import-DscResource -ModuleName xPendingReboot

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

        WindowsFeature ADCS-Web-Enrollment {
            Ensure    = 'Present'
            Name      = 'ADCS-Web-Enrollment'
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }

        WindowsFeature RSAT-ADCS-Mgmt {
            Ensure    = 'Present'
            Name      = 'RSAT-ADCS-Mgmt'
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }

        xADCSCertificationAuthority ADCS {
            Ensure     = 'Present'
            Credential = $domainCred
            CAType     = 'EnterpriseRootCA'
            CACommonName = $CARootName
            DependsOn  = '[WindowsFeature]ADCS-Cert-Authority'              
        }

        xADCSWebEnrollment CertSrv {
            Ensure           = 'Present'
            Credential       = $domainCred
            IsSingleInstance = "yes"
            DependsOn        = '[WindowsFeature]ADCS-Web-Enrollment', '[xADCSCertificationAuthority]ADCS'
        }
        

        xPendingReboot Reboot1
        { 
            Name      = "RebootServer"
            DependsOn = "[xADCSWebEnrollment]CertSrv"
        }


    
        

    }
}


