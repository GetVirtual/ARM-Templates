param saname string = 'bicepstoragejl123'

var vnetname    = 'VNET-bicep'
var vnetadressprefix = '10.140.0.0/24'

resource sta 'Microsoft.Storage/storageAccounts@2019-06-01' = {
    name: saname
    location: resourceGroup().location
    kind: 'Storage'
    sku: {
        name: 'Standard_LRS'
    }
}

resource vnet 'Microsoft.Network/virtualNetworks@2018-10-01' = {
    name: vnetname
    location: resourceGroup().location
    tags: {
      ProvisionedBy: 'Bicep'
    }
    properties: {
      addressSpace: {
        addressPrefixes: [
            vnetadressprefix
        ]
      }
      enableVmProtection: false
      enableDdosProtection: false
      subnets: [
        {
          name: 'default'
          properties: {
            addressPrefix: vnetadressprefix
          }
        }
      ]
    }
  }
