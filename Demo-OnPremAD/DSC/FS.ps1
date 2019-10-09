Configuration FS {

    [Parameter(Mandatory)]             
    [string]$domainname,
    [Parameter(Mandatory)]
    [string]$machinename,             
    [Parameter(Mandatory)]            
    [pscredential]$domainCred


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
