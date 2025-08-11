resource "azuread_application" "application" {
  display_name = var.name
  owners       = var.owners
}