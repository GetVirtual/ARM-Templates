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
        [string]$CAServerFQDN,
        [Parameter(Mandatory)]            
        [pscredential]$debugcred
    )  

    Import-DscResource -ModuleName xActiveDirectory   
    Import-DscResource -ModuleName CertificateDsc    
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

        WindowsFeature InstallADFS {
            Ensure    = "Present"
            Name      = "ADFS-Federation"
            DependsOn = "[PendingReboot]RebootAfterDomainJoin"
        }

        WaitForCertificateServices RootCA {
            CARootName           = $CARootName
            CAServerFQDN         = $CAServerFQDN
            RetryCount           = 20
            RetryIntervalSeconds = 60
            DependsOn = "[PendingReboot]RebootAfterDomainJoin"
        }

        CertReq SSLCert {
            CARootName          = $CARootName
            CAServerFQDN        = $CAServerFQDN
            Subject             = "CN=Onprem-ADFS.jrlobenz.rocks"
            KeyLength           = '2048'
            Exportable          = $true
            ProviderName        = "Microsoft RSA SChannel Cryptographic Provider"
            OID                 = '1.3.6.1.5.5.7.3.1'
            KeyUsage            = '0xa0'
            CertificateTemplate = 'Machine'
            AutoRenew           = $true
            FriendlyName        = 'SSL Cert for ADFS'
            Credential          = $domainCred
            KeyType             = 'RSA'
            RequestType         = 'CMC'
            DependsOn           = "[WaitForCertificateServices]RootCA"
            CAType = "Enterprise"
            UseMachineContext = $true
        }



        

    }
}
