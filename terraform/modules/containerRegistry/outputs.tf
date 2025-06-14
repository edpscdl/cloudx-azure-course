output "login_server" {
  value     = azurerm_container_registry.containerRegistry.login_server
  sensitive = true
}

output "admin_username" {
  value     = azurerm_container_registry.containerRegistry.admin_username
  sensitive = true
}

output "admin_password" {
  value     = azurerm_container_registry.containerRegistry.admin_password
  sensitive = true
}
