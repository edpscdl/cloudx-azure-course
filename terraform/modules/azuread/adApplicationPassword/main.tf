resource "azuread_application_password" "applicationPassword" {
  application_id = var.application_id
  display_name   = var.display_name
}
