Arun P <arunp.info@gmail.com>
	
12:16 AM (15 hours ago)
	
to me
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "az-eastus-rg-applicationname"
  location = "eastus"
}

resource "azurerm_key_vault" "vault" {
  name                       = az-eastus-kv-test
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.current_user_id

    key_permissions    = ["List", "Create", "Delete", "Get", "Purge"]
    secret_permissions = ["Set"]
  }
}
