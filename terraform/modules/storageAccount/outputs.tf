output "name" {
  value = azurerm_storage_account.storageAccount.name
}

output "key_name_storage_account_access_key" {
  value = azurerm_key_vault_secret.storageAccountAccessKey.name
}

output "key_name_storage_account_connection_string" {
  value = azurerm_key_vault_secret.storageAccountConnectionString.name
}
