output "secret_name_connection_string" {
  value = azurerm_key_vault_secret.applicationInsightsConnectionString.name
}