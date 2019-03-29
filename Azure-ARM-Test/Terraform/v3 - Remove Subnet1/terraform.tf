provider "azurerm" { 
    subscription_id = "180b44f4-1d54-4817-87ef-22ca8f374006"
}

# Cost Center Tag
variable "costcenter" {
  default = "DSCDemo"  
}

# Ressource Group
resource "azurerm_resource_group" "rg" {
   name     = "Test-Terraform"
  location = "West Europe"

  tags {
    project = "${var.costcenter}"
  }
}

# VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "Terraform-Demo-VNET"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["10.0.0.0/16"]

  tags {
    project = "${var.costcenter}"
  }
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.2.0/24"
}

# PublicIP
resource "azurerm_public_ip" "publicip" {
  name                         = "Terraform-Demo-IP"
  location                     = "West Europe"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"

  tags {
    project = "${var.costcenter}"
  }
}

