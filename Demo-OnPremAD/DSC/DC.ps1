Configuration DC {
    
    param             
    (             
        [Parameter(Mandatory)]             
        [string]$argument1,             
        [Parameter(Mandatory)]            
        [string]$argument2            
    )    


    Node 'localhost' {

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = 'ApplyOnly'
            ActionAfterReboot = 'ContinueConfiguration'
        }

        WindowsFeature ADDSInstall             
        {             
            Ensure = "Present"             
            Name = "AD-Domain-Services"             
        }            
            
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }  

    
        

    }
}


