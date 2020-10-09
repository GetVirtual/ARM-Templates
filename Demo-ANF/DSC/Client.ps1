Configuration Client {
    
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
    Import-DscResource -ModuleName ComputerManagementDsc

    Node 'localhost' {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
            ActionAfterReboot  = 'ContinueConfiguration'
        }

        xWaitForADDomain DscForestWait { 
            DomainName           = $domainname 
            DomainUserCredential = $domainCred
            RetryCount           = 20 
            RetryIntervalSec     = 60
        }

        Computer JoinDomain
        {
            Name       = $nodename 
            DomainName = $domainname 
            Credential = $domainCred
            DependsOn  = "[xWaitForADDomain]DscForestWait"
        }

        PendingReboot RebootAfterDomainJoin
        {
            Name = 'DomainJoin'
            DependsOn = "[Computer]JoinDomain"
        }

    }
}
