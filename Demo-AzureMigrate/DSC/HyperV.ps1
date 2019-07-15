Configuration HyperV {

    Import-DscResource -ModuleName 'xHyper-V'
    Import-DscResource -ModuleName 'PSDscResources'

    Node 'localhost' {

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ActionAfterReboot = 'ContinueConfiguration'
        }

        WindowsFeature Hyper-V {
            Ensure = "Present"
            Name   = "Hyper-V"
            IncludeAllSubFeature = $true

        }

        WindowsFeature Hyper-V-Powershell {
            Ensure = "Present"
            Name   = "Hyper-V-Powershell"
            IncludeAllSubFeature = $true
        }

        WindowsFeature Failover-Clustering {
            Ensure = "Present"
            Name   = "Failover-Clustering"
        }

        WindowsFeature Multipath-IO {
            Ensure = "Present"
            Name   = "Multipath-IO"
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
        
        WindowsFeature Hyper-V-Tools {
            Ensure = "Present"
            Name   = "Hyper-V-Tools"
            IncludeAllSubFeature = $true
        }
        
        xVMSwitch InternalSwitch
        {
            Ensure          = 'Present'
            Name            = 'NATSwitch'
            Type            = 'Internal'
            DependsOn       = '[WindowsFeature]Hyper-V-Powershell', '[WindowsFeature]Hyper-V'
        }

        Script Configure
        {
            GetScript = 
            {
                @{Result = "ConfigureHyperV"}
            }   

            TestScript = 
            {
                return $false
            }   

            SetScript =
            {
                $NatSwitch = Get-NetAdapter -Name "vEthernet (NATSwitch)"
                New-NetIPAddress -IPAddress 172.16.1.1 -PrefixLength 24 -InterfaceIndex $NatSwitch.ifIndex
                New-NetNat -Name NestedVMNATnetwork -InternalIPInterfaceAddressPrefix 172.16.1.0/24 -Verbose
            }
        }

    }
}
