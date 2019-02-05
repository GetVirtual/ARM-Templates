Configuration IIS {

    # Import the module that contains the resources we're using.
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    # The Node statement specifies which targets this configuration will be applied to.
    Node 'localhost' {

        # The first resource block ensures that the Web-Server (IIS) feature is enabled.
        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        Script generateIndex {
            SetScript = {
                $hostname = hostname
                ("<html><head><title>" + $hostname + "</title></head><body><h1>" + $hostname + "</h1></body></html>") | Out-File "C:\inetpub\wwwroot\index.html" -Force
            }
            TestScript = { Test-Path "C:\inetpub\wwwroot\index.html" }
            GetScript = { @{ Result = (Get-Content C:\inetpub\wwwroot\index.html) } }       
        }
    }
}
