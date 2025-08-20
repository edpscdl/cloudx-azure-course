resource "azurerm_log_analytics_workspace" "logAnalyticsWorkspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
}
