output "name" {
  value = azurerm_container_registry.containerRegistry.name
}

output "login_server" {
  value = azurerm_container_registry.containerRegistry.login_server
}

output "key_name_admin_login" {
  value = azurerm_key_vault_secret.containerRegistryAdminLogin.name
}

output "key_name_admin_password" {
  value = azurerm_key_vault_secret.containerRegistryAdminPassword.name
}

output "key_id_admin_login" {
  value = azurerm_key_vault_secret.containerRegistryAdminLogin.id
}