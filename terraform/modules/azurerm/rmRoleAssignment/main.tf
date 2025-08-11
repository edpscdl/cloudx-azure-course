resource "azurerm_role_assignment" "petStoreRoleAssigment" {
  for_each = toset(var.roles)

  role_definition_name = each.key
  scope                = var.scope
  principal_id         = var.assignee
  principal_type       = "ServicePrincipal"
}
