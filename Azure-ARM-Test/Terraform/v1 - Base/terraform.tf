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

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.1.0/24"
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

# NIC
resource "azurerm_network_interface" "nic-vm" {
  name                = "Terraform-Demo-nic"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "DSCVM-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }

  tags {
    project = "${var.costcenter}"
  }
}

# Virtual Machines
resource "azurerm_virtual_machine" "vm" {
  name                  = "Terraform-Demo"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic-vm.id}"]
  vm_size               = "Standard_B2ms"
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "Terraform-Demo--disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "tfdemo"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {

  }

  tags {
    project = "${var.costcenter}"
  }
}