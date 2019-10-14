Configuration FS {
    
    param             
    (   
        [Parameter(Mandatory)]             
        [string]$domainname,
        [Parameter(Mandatory)]
        [string]$nodename,             
        [Parameter(Mandatory)]            
        [pscredential]$domainCred,
        [Parameter(Mandatory)]            
        [string]$CARootName,
        [Parameter(Mandatory)]            
        [string]$CAServerFQDN
    )  

    Import-DscResource -ModuleName xActiveDirectory   
    Import-DscResource -ModuleName xComputerManagement
    Import-DscResource -ModuleName CertificateDsc    
    Import-DscResource -ModuleName xPendingReboot

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

        xComputer JoinDomain {
            Name       = $nodename 
            DomainName = $domainname 
            Credential = $domainCred  # Credential to join to domain
            DependsOn  = "[xWaitForADDomain]DscForestWait"
        }

        xPendingReboot Reboot1
        { 
            Name      = "RebootServer"
            DependsOn = "[xComputer]JoinDomain"
        }

        WindowsFeature InstallADFS {
            Ensure    = "Present"
            Name      = "ADFS-Federation"
            DependsOn = "[xPendingReboot]Reboot1"
        }

        WaitForCertificateServices RootCA {
            CARootName           = $CARootName
            CAServerFQDN         = $CAServerFQDN
            RetryCount           = 20
            RetryIntervalSeconds = 60
            DependsOn            = "[xPendingReboot]Reboot1"
        }



        

    }
}
