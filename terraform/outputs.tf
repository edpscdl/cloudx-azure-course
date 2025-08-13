output "secrets" {
  value = {
    AZURE_ACR_REGISTRY_NAME : module.petStoreContainerRegistry.name
    AZURE_RESOURCE_GROUP : var.main_resource_group_name
    FUNCTION_APP_NAME : module.petStoreFunctionAppPetStoreOrderReserver.name
    AZURE_ACR_REGISTRY_USERNAME : module.petStoreContainerRegistry.adminUsername
    AZURE_ACR_REGISTRY_PASSWORD : module.petStoreContainerRegistry.adminPassword
  }
  sensitive = true
}
