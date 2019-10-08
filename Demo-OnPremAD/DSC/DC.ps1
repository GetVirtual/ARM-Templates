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
            DomainName                    = $domainname             
            DomainAdministratorCredential = $domainCred             
            SafemodeAdministratorPassword = $safemodeCred          
            DatabasePath                  = 'C:\NTDS'            
            LogPath                       = 'C:\NTDS'            
            DependsOn                     = "[WindowsFeature]ADDSInstall"           
        } 

    
        

    }
}


