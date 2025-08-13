resource "azuread_application_redirect_uris" "applicationRedirectUris" {
  application_id = var.applicationRegistrationId
  type           = "Web"

  redirect_uris = var.redirectUris
}