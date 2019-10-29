<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGetVirtual%2FAzure-ARM%2Fmaster%2FDemo-OnPremAD%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/GetVirtual/Azure-ARM/master/Demo-OnPremAD/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

### Description ###

ARM Template to simulate "On Premises services" with preconfigured DC and prepared servers for AD FS, Fileserver, etc.
Examples for test scenarios:
* AD Connect (Sync AD and AAD)
* Azure File Sync (https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)
* and many more hybrid scenarios you maybe want to test ...

WARNING:
This is a deployment for testing & learning scenarios with PublicIPs (+NSG) attached in order to establish a quick connection.
Don´t use this with sensitive data or in a production environment.


## Deployed resources ##
* Domain Controller: AD Roles installed & configured, AD CS installed & configured
* AD FS: Domain Joined, AD FS Role installed, Certificate issued
* File-Server: Domain Joined
* Client: Domain Joined

## Parameters ##
* Username for all VMs (default: vmadmin)
* Password for all VMs
* DNS Labels for all VMs
* Domain Name

![arm](https://raw.githubusercontent.com/GetVirtual/Azure-ARM/master/Demo-OnPremAD/arm.png "ARM")




