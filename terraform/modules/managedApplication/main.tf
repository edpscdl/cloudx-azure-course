data "azuread_client_config" "currentAd" {}
data "azurerm_client_config" "currentRm" {}

resource "azuread_application" "application" {
  display_name = var.name
  owners       = [data.azuread_client_config.currentAd.object_id]
}

resource "azuread_service_principal" "servicePrincipal" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.currentAd.object_id]
}

resource "azuread_application_password" "applicationPassword" {
  application_id = azuread_application.application.id
  display_name   = "rbac"
}
