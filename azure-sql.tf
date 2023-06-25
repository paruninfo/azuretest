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


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}

resource "azurerm_virtual_network" "sqlvnet" {
  name                = "az-sql-server-subnet-network"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus-2"
  resource_group_name = "azurerm_resource_group.rg.name"
}

resource "azurerm_subnet" "sqlsubnet" {
  name                 = "az-sql-server-subnet"
  resource_group_name  = "azurerm_resource_group.rg.name"
  virtual_network_name = azurerm_virtual_network.sqlvnet.name
  address_prefix       = "10.0.1.0/24"

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_mssql_server" "server" {
  name                         = "az-ms-sql-server-test"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
}

resource "azurerm_private_endpoint" "sqlpvtendpoint" {
  name                = "az-sql-endpoint"
  location            = "eastus-2"
  resource_group_name = "azurerm_resource_group.rg.name"
  subnet_id           = azurerm_subnet.sqlsubnet.id

  private_service_connection {
    name                           = "az-privateserviceconnection"
    private_connection_resource_id = azurerm_mssql_server.server.id
    subresource_names              = [ "sqldbServer" ]
    is_manual_connection           = false
  }
}
