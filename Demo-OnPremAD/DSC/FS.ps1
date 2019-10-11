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

        WindowsFeature InstallADFS {
            Ensure    = "Present"
            Name      = "ADFS-Federation"
            DependsOn = "[xComputer]JoinDomain"
        }

        WaitForCertificateServices RootCA {
            CARootName           = $CARootName
            CAServerFQDN         = $CAServerFQDN
            RetryCount           = 20
            RetryIntervalSeconds = 60
            DependsOn            = "[xComputer]JoinDomain"
        }

        CertReq SSLCert {
            CARootName          = $CARootName
            CAServerFQDN        = $CAServerFQDN
            Subject             = $nodename
            KeyLength           = '2048'
            Exportable          = $true
            ProviderName        = '"Microsoft RSA SChannel Cryptographic Provider"'
            OID                 = '1.3.6.1.5.5.7.3.1'
            KeyUsage            = '0xa0'
            CertificateTemplate = 'WebServer'
            SubjectAltName      = 'dns=fabrikam.com&dns=contoso.com'
            AutoRenew           = $true
            FriendlyName        = 'SSL Cert for ADFS'
            Credential          = $domainCred
            KeyType             = 'RSA'
            RequestType         = 'CMC'
            DependsOn           = "[WaitForCertificateServices]RootCA"
        
        
        }

        

    }
}
