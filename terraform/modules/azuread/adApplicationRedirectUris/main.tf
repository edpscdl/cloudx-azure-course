resource "azuread_application_redirect_uris" "example_web" {
  application_id = var.application_registration_id
  type           = var.type

  redirect_uris = var.redirect_uris
}