<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGetVirtual%2FAzure-ARM%2Fmaster%2FDemo-AzureMigrate%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/GetVirtual/Azure-ARM/master/Demo-AzureMigrate/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

---

## Azure Migrate Demo Environment - ARM Template

![azuremigrate](https://azuremigratedemo.blob.core.windows.net/vms/AzureMigrate.jpg "Azure Migrate")

### ARM Template provides
* Azure Virtual Machine with Hyper-V installed and configured
* Download and Import for the nested Azure Migrate Appliance VM
* Download and Import for a nested test migration VM (MigrationVM)

The download and import jobs will take some time (about 45 minutes)...
deployment is complete when both vms are up & running.

### What do you have to do?
* Create Azure Migrate Project in Azure (cant be done with ARM right now)
* Connect to the Azure Migrate Appliance from the Hyper-V Host via RDP or Hyper-V console 
* ...and finish the configuration wizard & connect the appliance to Azure Migrate (see below for network infos and credentials for the Hyper-V)

A great reference is the blog post from Thomas Maurer: https://www.thomasmaurer.ch/2019/07/assess-and-migrate-hyper-v-vms-with-azure-migrate/

### Credentials
* Hyper-V Host: for you to choose with the ARM template deployment (default: vmadmin // $ecurity#123)
* Azure Migrate Appliance: Administrator // $ecurity#123
* Migration VM: Administrator // $ecurity#123

### Hyper-V NAT Network Details
* Hyper-V Host: 172.16.1.1
* Azure Migrate Appliance: 172.16.1.2
* Migration VM: 172.16.1.3





