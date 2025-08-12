resource "azuread_application_owner" "applicationOwner" {
  application_id  = var.application_id
  owner_object_id = var.owner_object_id
}