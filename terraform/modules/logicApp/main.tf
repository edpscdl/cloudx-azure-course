resource "azurerm_logic_app_workflow" "logicAppWorkflow" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
}
