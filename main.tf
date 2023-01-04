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
  client_id       = var.clientId
  client_secret   = var.clientSecret
  tenant_id       = var.tenantId
  features {

  }
}

# Create RG
resource "azurerm_resource_group" "rg" {
  name     = var.RGName
  location = var.location

}

module "vnet" {
  source   = "./module-1"
  RGName   = var.RGName
  location = var.location
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "storage" {
  source          = "./module-2"
  RGName          = var.RGName
  location        = var.location
  blob_container  = var.blob_container
  blob_container2 = var.blob_container2
}

module "vm" {
  source   = "./module-3"
  RGName   = var.RGName
  location = var.location


}