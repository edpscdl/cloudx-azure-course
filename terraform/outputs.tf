output "secrets" {
  value = {
    AZURE_ACR_REGISTRY_NAME : module.petStoreContainerRegistry.name
    AZURE_RESOURCE_GROUP : var.main_resource_group_name
    FUNCTION_APP_NAME : module.petStoreFunctionAppPetStoreOrderReserver.name
    AZURE_ACR_REGISTRY_USERNAME : module.petStoreContainerRegistry.adminUsername
    AZURE_ACR_REGISTRY_PASSWORD : module.petStoreContainerRegistry.adminPassword
    AZURE_CREDENTIALS : jsonencode({
      clientId       = module.petStoreEntraIdApplication.client_id
      clientSecret   = module.petStoreEntraIdApplicationPassword.value
      subscriptionId = data.azurerm_client_config.current.subscription_id
      tenantId       = data.azurerm_client_config.current.tenant_id
    })
  }
  sensitive = true
}
