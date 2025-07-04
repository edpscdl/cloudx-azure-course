resource "azurerm_storage_account" "storageAccount" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
}

resource "azurerm_storage_container" "storageAccountContainer" {
  name                  = "archive"
  storage_account_id    = azurerm_storage_account.storageAccount.id
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "storageAccountAccessKey" {
  name         = "storage-account-primary-access-key"
  value        = azurerm_storage_account.storageAccount.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "storageAccountConnectionString" {
  name         = "storage-account-primary-connection-string"
  value        = azurerm_storage_account.storageAccount.primary_connection_string
  key_vault_id = var.key_vault_id
}
