terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

provider "azurerm" {
    subscription_id = var.subscriptionId
    client_id = var.clientId
    client_secret = var.clientSecret
    tenant_id = var.tenantId
  features {

  }
}

# Create RG
resource "azurerm_resource_group" "rg" {
    name = var.RGName
    location = var.location
  
}

# Create VNet
resource "azurerm_virtual_network" "vnet" {
    name = "vnet"
    location = var.location
    resource_group_name = var.RGName
    address_space = [ "10.0.0.0/16" ]
    depends_on = [
      azurerm_resource_group.rg
    ]
  
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name = "subnet1"
    resource_group_name = var.RGName
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.10.0/24" ]
  
}