terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}
module "vnet" {
  source = "../module-1"
  location = var.location
  RGName = var.RGName


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
    name                 = "internal"
    subnet_id            = module.vnet.azurerm_subnet.id
    private_ip_address_allocation = "Static"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }

}