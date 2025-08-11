output "id" {
  value = azurerm_container_registry.containerRegistry.id
}

output "name" {
  value = azurerm_container_registry.containerRegistry.name
}

output "adminUsername" {
  value = azurerm_container_registry.containerRegistry.admin_username
}

output "adminPassword" {
  value = azurerm_container_registry.containerRegistry.admin_password
}

output "secret_name_login_server" {
  value = azurerm_key_vault_secret.containerRegistryLoginServer.name
}

output "secret_name_admin_username" {
  value = azurerm_key_vault_secret.containerRegistryAdminUsername.name
}

output "secret_name_admin_password" {
  value = azurerm_key_vault_secret.containerRegistryAdminPassword.name
}
