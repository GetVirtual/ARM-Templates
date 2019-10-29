<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGetVirtual%2FAzure-ARM%2Fmaster%2FDemo-OnPremAD%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/GetVirtual/Azure-ARM/master/Demo-OnPremAD/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


## Description ##

The ARM Template deploys
* Domain Controller: AD Roles installed & configured, AD CS installed & configured
* AD FS: Domain Joined, Role installed, Certificate issued
* File-Server: Domain Joined, Role installed
* Client: Domain Joined

Parameters:
* Username for all VMs (default: vmadmin)
* Password for 



