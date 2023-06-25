resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
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
  depends_on = [ azurerm_service_plan.appserviceplan ]

  name                  = "az-eastus-webapp-applicationname"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config {
    minimum_tls_version = "1.2"
  }
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

resource azurerm_storage_account "primary" {
  name                     = "az-eastus-storage-test"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kine             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
#optional
resource azurerm_storage_container "myblobs" {
  name                  = "myblobs"
  storage_account_name  = azurerm_storage_account.primary.name
  container_access_type = "private"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_mssql_server" "server" {
  name                         = "az-ms-sql-server-test"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = random_password.password.result
  minimum_tls_version          = 1.2
  public_network_access_enabled = true
  version                      = "12.0"
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = var.sku_name
}

