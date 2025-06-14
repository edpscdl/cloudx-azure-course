resource "azurerm_container_registry" "containerRegistry" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
}

resource "azurerm_key_vault_secret" "containerRegistryAdminPassword" {
  name         = "${var.name}-administrator-password"
  value        = azurerm_container_registry.containerRegistry.admin_password
  key_vault_id = var.key_vault_id
}