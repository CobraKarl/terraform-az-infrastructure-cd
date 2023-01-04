terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

# Create Random String
resource "random_string" "resource_string" {
  length  = 6
  special = false
  upper   = false
}

# Create Storage Account
resource "azurerm_storage_account" "storage" {
  name                = "storage${random_string.resource_string.result}"
  resource_group_name = var.RGName
  location            = var.location
  account_tier        = "Standard"

  account_replication_type = "LRS"
  allow_blob_public_access = true
}

# Create Blob container
resource "azurerm_storage_container" "blob_container" {
  name                  = var.blob_container
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"

}