<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGetVirtual%2FAzure-ARM%2Fmaster%2FDemo-AzureMigrate%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/GetVirtual/Azure-ARM/master/Demo-AzureMigrate/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

---

## Azure Migrate Demo Environment - ARM Template

![azuremigrate](https://azuremigratedemo.blob.core.windows.net/vms/AzureMigrate.jpg "Azure Migrate")

### The ARM Template provides
* Azure Virtual Machine with Hyper-V installed and configured
* Azure Migrate Appliance (preconfigured networking, downloaded & nested import)
* Migration VM (blank Windows Server 2019 install, preconfigured networking, downloaded & nested import)

The download and import jobs will take some time (about 45 minutes)... the deployment is complete when both nested vms are up & running.

### Instructions
1. Deploy the ARM template to your subscription (choose a unique DNS name to your liking)
2. Create a Azure Migrate Project within the Azure Portal (can´t be done with ARM right now)
    * Choose the Microsoft assessment tools
    * Choose the Microsoft migration tools
3. Connect to the Hyper-V server & deactivate the Windows firewall
4. Connect to the Azure Migrate Appliance from the Hyper-V Host via RDP or Hyper-V console
    * https://appliancename-or-IPAddress:44368
    * Tip: Adjust the language setting in the Azure Migrate appliance to your regional settings
    * Open the Migration Appliance configuration web page
    * Click through the appliance connectivity and update checks. If you receive a prompt for credentials at this stage, simply close it.
    * After the successful update scroll to the top and acknowledge the restart prompt. Again click through the appliance connectivity and update checks.
    * Log in to your Azure account
    * Connect to your Azure Migrate project you´ve created in step 2. You can choose the appliance name - it doesn´t need to match the actual name of the appliance.
    * Add the credentials and network infos for your Hyper-V (see below)
    * Save & start discovery and wait for it to finish

You´ve successfully linked your Azure Migrate project to your appliance. From now on you can use the Azure Portal to control Azure Migrate.
A great reference on how to use Azure Migrate from this point on, is the blog post from Thomas Maurer: https://www.thomasmaurer.ch/2019/07/assess-and-migrate-hyper-v-vms-with-azure-migrate/

### Credentials
* Hyper-V Host: for you to choose with the ARM template deployment (default: vmadmin // $ecurity#123)
* Azure Migrate Appliance: Administrator // $ecurity#123
* Migration VM: Administrator // $ecurity#123

### Hyper-V NAT Network Details
* Hyper-V Host: 172.16.1.1
* Azure Migrate Appliance: 172.16.1.2, Azure Migrate Appliance https://172.16.1.2:44368
* Migration VM: 172.16.1.3


Special thanks to Sarah Lean for the article about lab deployment in Azure - https://www.techielass.com/lab-deployment-in-azure
