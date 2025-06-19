resource "azurerm_container_registry" "containerRegistry" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_key_vault_secret" "containerRegistryLoginServer" {
  name         = "container-registry-login-server"
  value        = azurerm_container_registry.containerRegistry.login_server
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "acr_pull_role" {
  principal_id   = var.user_assigned_identity_principal_id
  scope          = azurerm_container_registry.containerRegistry.id
  role_definition_name = "AcrPull"
}
