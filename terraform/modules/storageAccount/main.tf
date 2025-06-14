resource "azurerm_storage_account" "storageAccount" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
}

resource "azurerm_storage_container" "storageAccountContainer" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storageAccount.id
  container_access_type = var.container_access_type
}

resource "azurerm_key_vault_secret" "storageAccountAccessKey" {
  name         = "${var.name}-primary-access-key"
  value        = azurerm_storage_account.storageAccount.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "storageAccountConnectionString" {
  name         = "${var.name}-primary-connection-string"
  value        = azurerm_storage_account.storageAccount.primary_connection_string
  key_vault_id = var.key_vault_id
}
