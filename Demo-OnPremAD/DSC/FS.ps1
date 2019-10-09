Configuration FS {

    [Parameter(Mandatory)]             
    [string]$domainname,             
    [Parameter(Mandatory)]            
    [pscredential]$domainCred,
    [Parameter(Mandatory)]
    [string]$machinename

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
            RetryCount           = $RetryCount 
            RetryIntervalSec     = $RetryIntervalSec
        }

        xComputer JoinDomain
        {
            Name       = $machinename 
            DomainName = $domainname 
            Credential = $domainCred  # Credential to join to domain
            DependsOn  = "[xWaitForADDomain]DscForestWait"
        }



        

    }
}
