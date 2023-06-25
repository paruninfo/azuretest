resource azurerm_storage_account "primary" {
  name                     = "az-eastus-storage-test"
  resource_group_name      = azurerm_resource_group.primary.name
  location                 = azurerm_resource_group.primary.location
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
