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
                # Extend disk
                Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size (500GB)
                
                # Create NAT Switch und assign IP on the interface
                $NatSwitch = Get-NetAdapter -Name "vEthernet (NATSwitch)"
                New-NetIPAddress -IPAddress 172.16.1.1 -PrefixLength 24 -InterfaceIndex $NatSwitch.ifIndex
                New-NetNat -Name NestedVMNATnetwork -InternalIPInterfaceAddressPrefix 172.16.1.0/24 -Verbose
                #Add-NetNatStaticMapping -NatName "NATMigrationAppliance" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.1.2 -InternalPort 44368 -ExternalPort 44368
               
                # Download & Start Azure Migrate Appliance
                Add-Type -assembly "system.io.compression.filesystem"
                $URL = "https://azuremigratedemo.blob.core.windows.net/vms/AzureMigrateAppliance.zip"
                $DLFile = "D:\AzureMigrateAppliance.zip"
                Invoke-WebRequest $URL -OutFile $DLFile
                [io.compression.zipfile]::ExtractToDirectory($DLFile, "C:\VirtualMachines")
                Import-VM -Path 'C:\VirtualMachines\AzureMigrateAppliance\Virtual Machines\53FF67B5-C68F-4099-BAF7-91FECDD524BD.XML'
                Start-VM -Name AzureMigrateAppliance

                # Download & Start MigrationVM
                $URL = "https://azuremigratedemo.blob.core.windows.net/vms/MigrationVM.zip"
                $DLFile = "D:\MigrationVM.zip"
                Invoke-WebRequest $URL -OutFile $DLFile
                [io.compression.zipfile]::ExtractToDirectory($DLFile, "C:\VirtualMachines")
                Import-VM -Path 'C:\VirtualMachines\MigrationVM\Virtual Machines\C50E94CD-0B7E-41AE-957C-3A3846E28751.vmcx'
                Start-VM -Name MigrationVM

            }

            DependsOn = '[xVMSwitch]InternalSwitch'
        }

    }
}
