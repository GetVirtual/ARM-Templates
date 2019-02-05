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

        Script webrequest {
            SetScript = {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                Invoke-WebRequest "https://github.com/GetVirtual/ARM-Templates/raw/master/MultiRegionHA/DSC/index.html" -OutFile "C:\inetpub\wwwroot\index.html"
            }
            TestScript = { Test-Path "C:\inetpub\wwwroot\index.html" }
            GetScript = { @{ Result = (Get-Content C:\inetpub\wwwroot\index.html) } }       
        }

        Script generateIndex {
            SetScript = {
                $hostname = hostname
                write-host ("<html><head><title>" + $hostname + "</title></head><body>" + $hostname + "</body></html>") | Out-File "C:\inetpub\wwwroot\index2.html" -Force
            }
            TestScript = { Test-Path "C:\inetpub\wwwroot\index2.html" }
            GetScript = { @{ Result = (Get-Content C:\inetpub\wwwroot\index2.html) } }       
        }
    }
}
