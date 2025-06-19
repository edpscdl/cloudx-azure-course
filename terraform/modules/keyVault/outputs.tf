output "name" {
  value = azurerm_key_vault.keyVault.name
}

output "id" {
  value = azurerm_key_vault.keyVault.id
}

output "env" {
  value = {
    AZURE_KEY_VAULT_ENDPOINT=azurerm_key_vault.keyVault.vault_uri
  }
}
