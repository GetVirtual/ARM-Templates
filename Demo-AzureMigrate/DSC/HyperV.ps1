Configuration HyperV {

    Import-DscResource -ModuleName 'xHyper-V'
    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'xPendingReboot'

    Node 'localhost' {

        
        MsiPackage InstallWindowsAdminCenter
        {
            ProductId = '{4FAE3A2E-4369-490E-97F3-0B3BFF183AB9}'
            Path      = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter1809.5.msi'
            Arguments = "/qn /l*v c:\windows\temp\windowsadmincenter.msiinstall.log SME_PORT=6516 SSL_CERTIFICATE_OPTION=generate"
            Ensure    = 'Present'
        }

        WindowsFeature Hyper-V {
            Ensure = "Present"
            Name   = "Hyper-V"
            IncludeAllSubFeature = $true
        }

        WindowsFeature Failover-Clustering {
            Ensure = "Present"
            Name   = "Failover-Clustering"
        }

        WindowsFeature Hyper-V-Powershell {
            Ensure = "Present"
            Name   = "Hyper-V-Powershell"
            IncludeAllSubFeature = $true
        }

        WindowsFeature Multipath-IO {
            Ensure = "Present"
            Name   = "Multipath-IO "
            IncludeAllSubFeature = $true
        }

        WindowsFeature RSAT-Shielded-VM-Tools {
            Ensure = "Present"
            Name   = "RSAT-Shielded-VM-Tools"
            IncludeAllSubFeature = $true
        }
        
        WindowsFeature RSAT-Clustering-Powershell {
            Ensure = "Present"
            Name   = "RSAT-Clustering-Powershell"
            IncludeAllSubFeature = $true
        }
        
        xPendingReboot AfterHyperVInstall
        {
            Name        = "AfterHyperVInstall"
            DependsOn   = '[WindowsFeature]Hyper-V', '[WindowsFeature]Hyper-V-Powershell', '[WindowsFeature]Failover-Clustering', '[MsiPackage]InstallWindowsAdminCenter'
        }

        xVMSwitch InternalSwitch
        {
            Ensure          = 'Present'
            Name            = 'NatSwitch'
            Type            = 'Internal'
            DependsOn       = '[xPendingReboot]AfterHyperVInstall'
        }

    }
}
