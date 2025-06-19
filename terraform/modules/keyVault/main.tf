data "azurerm_client_config" "currentClientInfo" {}

resource "azurerm_key_vault" "keyVault" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.currentClientInfo.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_access_policy" "portal_user" {
  key_vault_id = azurerm_key_vault.keyVault.id
  tenant_id    = data.azurerm_client_config.currentClientInfo.tenant_id
  object_id    = data.azurerm_client_config.currentClientInfo.object_id

  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
}

resource "azurerm_key_vault_access_policy" "user_assigned_identity" {
  key_vault_id = azurerm_key_vault.keyVault.id
  tenant_id    = data.azurerm_client_config.currentClientInfo.tenant_id
  object_id    = var.user_assigned_identity_principal_id

  secret_permissions      = ["Get", "List"]
}

resource "azurerm_role_assignment" "acr_pull_role" {
  principal_id   = var.user_assigned_identity_principal_id
  scope          = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Secrets User"
}
