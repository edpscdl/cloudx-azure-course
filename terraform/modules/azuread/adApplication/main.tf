data "azuread_client_config" "current" {}

resource "azuread_application_registration" "applicationRegistration" {
  display_name = var.applicationRegistrationDisplayName
}

# resource "azuread_application_owner" "applicationOwner" {
#   application_id  = azuread_application_registration.applicationRegistration.id
#   owner_object_id = data.azuread_client_config.current.object_id
# }

resource "azuread_service_principal" "servicePrincipal" {
  client_id                    = azuread_application_registration.applicationRegistration.client_id
  app_role_assignment_required = false
  # owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "applicationPassword" {
  application_id = azuread_application_registration.applicationRegistration.id
  display_name   = var.applicationPasswordDisplayName
}
