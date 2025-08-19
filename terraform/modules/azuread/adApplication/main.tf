data "azuread_client_config" "current" {}
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "microsoftGraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

resource "azuread_application_registration" "applicationRegistration" {
  display_name       = var.applicationRegistrationDisplayName
  sign_in_audience   = "AzureADMyOrg"
}

resource "azuread_application_api_access" "graph_permissions" {
  application_id = azuread_application_registration.applicationRegistration.id

  api_client_id  = data.azuread_service_principal.microsoftGraph.client_id

  scope_ids = [
    data.azuread_service_principal.microsoftGraph.oauth2_permission_scope_ids["openid"],
    data.azuread_service_principal.microsoftGraph.oauth2_permission_scope_ids["offline_access"]
  ]
}

resource "azuread_application_owner" "applicationOwner" {
  application_id  = azuread_application_registration.applicationRegistration.id
  owner_object_id = data.azuread_client_config.current.object_id
}

resource "azuread_service_principal" "servicePrincipal" {
  client_id                    = azuread_application_registration.applicationRegistration.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "applicationPassword" {
  application_id = azuread_application_registration.applicationRegistration.id
  display_name   = var.applicationPasswordDisplayName
}

resource "azuread_service_principal_delegated_permission_grant" "servicePrincipalDelegatedPermissionGrant" {
  service_principal_object_id = azuread_service_principal.servicePrincipal.object_id
  resource_service_principal_object_id = data.azuread_service_principal.microsoftGraph.object_id

  claim_values = [
    data.azuread_service_principal.microsoftGraph.oauth2_permission_scope_ids["openid"],
    data.azuread_service_principal.microsoftGraph.oauth2_permission_scope_ids["offline_access"]
  ]
}