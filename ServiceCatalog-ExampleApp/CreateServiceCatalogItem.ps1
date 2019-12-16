param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the User Principal Name that gets permission to manage the app")][string]$UPN, 
    [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the storage account that will be created for storing the zipped templates")][string]$storageaccountname
)

# Register Azure Solutions if necessary
# Register-AzResourceProvider -ProviderNamespace Microsoft.Solutions

# Variables
$rg = "servicecatalog"
$filename = "sc_storageaccount.zip"
$location = "westeurope"

# Create / Update ZIP File
Compress-Archive -Path .\*.json -Update -DestinationPath .\sc_storageaccount.zip

# Create RG
New-AzResourceGroup -Name $rg -Location $location 

# Create Storage Account and Container
$storageAccount = New-AzStorageAccount -ResourceGroupName $rg -Name $storageaccountname -Location $location -SkuName Standard_LRS -Kind Storage
New-AzStorageContainer -Name appcontainer -Context $storageAccount.Context -Permission blob

# Uploade Service Catalog Item 
Set-AzStorageBlobContent -File $filename -Container appcontainer -Blob $filename -Context $storageAccount.Context 

# Get ID for your User and the Role ID for "Owner"
$userID=(get-azaduser -UserPrincipalName $UPN).Id
$ownerID=(Get-AzRoleDefinition -Name Owner).Id

# Reference Blob
$blob = Get-AzStorageBlob -Container appcontainer -Blob $filename -Context $storageAccount.Context

# Create Service Catalog Managed Application Definition
New-AzManagedApplicationDefinition -Name "ManagedStorage" -Location $location -ResourceGroupName $rg -LockLevel ReadOnly `
  -DisplayName "Managed Storage Account" -Description "Managed Storage Account" -Authorization "${userID}:$ownerID" -PackageFileUri $blob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri

