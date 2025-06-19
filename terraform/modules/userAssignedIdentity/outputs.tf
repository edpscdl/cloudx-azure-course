output "id" {
  value = azurerm_user_assigned_identity.userAssignedIdentity.id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.userAssignedIdentity.principal_id
}

output "client_id" {
  value = azurerm_user_assigned_identity.userAssignedIdentity.client_id
}

output "env" {
  value = {
    AZURE_CLIENT_ID=azurerm_user_assigned_identity.userAssignedIdentity.client_id
  }
}