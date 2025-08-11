output "client_id" {
  value = azuread_application.application.client_id
}

output "credentials" {
  value = jsonencode({
    clientId       = azuread_application.application.client_id
    clientSecret   = azuread_application_password.applicationPassword.value
    subscriptionId = data.azurerm_client_config.currentRm.subscription_id
    tenantId       = data.azurerm_client_config.currentRm.tenant_id
  })
}