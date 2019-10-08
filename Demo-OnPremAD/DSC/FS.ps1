Configuration FS {

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

        

    }
}
