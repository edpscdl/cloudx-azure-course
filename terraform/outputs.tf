output "secrets" {
  value = {
    AZURE_ACR_REGISTRY_NAME: module.containerRegistry.name
    AZURE_RESOURCE_GROUP: var.main_resource_group_name
    FUNCTION_APP_NAME: module.functionAppPetStoreOrderReserver.name
    AZURE_ACR_REGISTRY_USERNAME: module.containerRegistry.adminUsername
    AZURE_ACR_REGISTRY_PASSWORD: module.containerRegistry.adminPassword
    AZURE_CREDENTIALS: module.managedApplicationPetStoreGitHub.credentials
  }
  sensitive = true
}
