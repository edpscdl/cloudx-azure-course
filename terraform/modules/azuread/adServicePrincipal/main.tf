resource "azuread_service_principal" "servicePrincipal" {
  client_id                    = var.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.currentAd.object_id]
}