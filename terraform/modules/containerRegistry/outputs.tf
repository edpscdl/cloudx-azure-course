output "key_name_login_server" {
  value = azurerm_key_vault_secret.containerRegistryLoginServer.name
}

output "key_name_admin_login" {
  value = azurerm_key_vault_secret.containerRegistryAdminLogin.name
}

output "key_name_admin_password" {
  value = azurerm_key_vault_secret.containerRegistryAdminPassword.name
}
