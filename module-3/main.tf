terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}
module "vnet" {
  source   = "../module-1"
  location = var.location
  RGName   = var.RGName

}

# Create Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pubipforvm"
  resource_group_name = var.RGName
  location            = var.location
  allocation_method   = "Static"

}

# Create Nic
resource "azurerm_network_interface" "nicforvm" {
  name                = "nicforvm"
  resource_group_name = var.RGName
  location            = var.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.azurerm_subnet_id
    private_ip_address            = "10.0.10.5"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }

}

# Create Virtual Machine 
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm1"
  resource_group_name = var.RGName
  location            = var.location
  size                = "Standard_B2ms"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nicforvm.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}

# Create network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  resource_group_name = var.RGName
  location            = var.location
}

# Create netwrok security rule
resource "azurerm_network_security_rule" "nsgrule_rdp" {
  name                        = "rdp"
  resource_group_name         = var.RGName
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"


}