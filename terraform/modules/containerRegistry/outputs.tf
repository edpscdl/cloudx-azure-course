output "secret_name_login_server" {
  value = azurerm_key_vault_secret.containerRegistryLoginServer.name
}

output "secret_name_admin_username" {
  value = azurerm_key_vault_secret.containerRegistryAdminUsername.name
}

output "secret_name_admin_password" {
  value = azurerm_key_vault_secret.containerRegistryAdminPassword.name
}
