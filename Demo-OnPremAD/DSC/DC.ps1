Configuration DC {
    
    param             
    (             
        [Parameter(Mandatory)]             
        [string]$domainname,             
        [Parameter(Mandatory)]            
        [string]$safemodeAdministratorCred            
    )    

    Import-DscResource -ModuleName xActiveDirectory   

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

        # No slash at end of folder paths            
        xADDomain FirstDS             
        {             
            DomainName                    = $Node.DomainName             
            DomainAdministratorCredential = $domainCred             
            SafemodeAdministratorPassword = $safemodeAdministratorCred            
            DatabasePath                  = 'C:\NTDS'            
            LogPath                       = 'C:\NTDS'            
            DependsOn                     = "[WindowsFeature]ADDSInstall"           
        } 

    
        

    }
}


