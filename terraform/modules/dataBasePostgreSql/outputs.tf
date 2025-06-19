output "server_id" {
  value = azurerm_postgresql_flexible_server.postgresql.id
}

output "env_direct_urls" {
  value = {
    URL_SECRET_POSTRGRESQL_HOST="${data.azurerm_key_vault.keyVault.vault_uri}secrets/${azurerm_key_vault_secret.postgresqlServerHost.name}/${azurerm_key_vault_secret.postgresqlServerHost.version}"
    URL_SECRET_POSTRGRESQL_PORT="${data.azurerm_key_vault.keyVault.vault_uri}secrets/${azurerm_key_vault_secret.postgresqlServerPort.name}/${azurerm_key_vault_secret.postgresqlServerPort.version}"
    URL_SECRET_POSTRGRESQL_USER_NAME="${data.azurerm_key_vault.keyVault.vault_uri}secrets/${azurerm_key_vault_secret.postgresqlUserName.name}/${azurerm_key_vault_secret.postgresqlUserName.version}"
    URL_SECRET_POSTRGRESQL_USER_PASSWORD="${data.azurerm_key_vault.keyVault.vault_uri}secrets/${azurerm_key_vault_secret.postgresqlUserPassword.name}/${azurerm_key_vault_secret.postgresqlUserPassword.version}"
  }
}