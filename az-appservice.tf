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

# Create the Windows App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "az-eastus-appservice-applicationname"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P2v2"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_windows_web_app" "webapp" {
  name                  = "az-eastus-webapp-applicationname"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config {
    minimum_tls_version = "1.2"
  }
}
