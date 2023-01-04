terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

# Create VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = var.RGName
  address_space       = ["10.0.0.0/16"]

}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = var.RGName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/24"]

}

output "azurerm_subnet" {
  value = azurerm_subnet.subnet.id
}