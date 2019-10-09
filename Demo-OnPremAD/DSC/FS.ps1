Configuration FS {
    
    param             
    (   
        [Parameter(Mandatory)]             
        [string]$domainname,
        [Parameter(Mandatory)]
        [string]$nodename,             
        [Parameter(Mandatory)]            
        [pscredential]$domainCred
    )  

    Import-DscResource -ModuleName xActiveDirectory   
    Import-DscResource -ModuleName xComputerManagement

    Node 'localhost' {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
            ActionAfterReboot  = 'ContinueConfiguration'
        }

        xWaitForADDomain DscForestWait { 
            DomainName           = $domainname 
            DomainUserCredential = $domainCred
            RetryCount           = 20 
            RetryIntervalSec     = 30
        }

        xComputer JoinDomain
        {
            Name       = $nodename 
            DomainName = $domainname 
            Credential = $domainCred  # Credential to join to domain
            DependsOn  = "[xWaitForADDomain]DscForestWait"
        }



        

    }
}
