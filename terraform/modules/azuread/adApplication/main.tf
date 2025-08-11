resource "azuread_application" "application" {
  display_name = var.name
  owners       = [data.azuread_client_config.currentAd.object_id]
}