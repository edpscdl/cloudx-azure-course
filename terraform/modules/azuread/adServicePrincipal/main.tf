resource "azuread_service_principal" "servicePrincipal" {
  client_id                    = var.client_id
  app_role_assignment_required = false
  owners                       = var.owners
}