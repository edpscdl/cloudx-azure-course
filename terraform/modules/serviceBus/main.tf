resource "azurerm_servicebus_namespace" "serviceBusNamespace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Standard"
  local_auth_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
}

resource "azurerm_servicebus_queue" "serviceBusQueue" {
  name         = "order_history_queue"
  namespace_id = azurerm_servicebus_namespace.serviceBusNamespace.id

  dead_lettering_on_message_expiration = true
  max_delivery_count = 3
}

resource "azurerm_servicebus_queue_authorization_rule" "serviceBusQueueAuthorizationRule" {
  name = "order_history_queue_access"
  queue_id = azurerm_servicebus_queue.serviceBusQueue.id

  listen = true
  send = true
  manage = false
}

resource "azurerm_key_vault_secret" "serviceBusQueueConnectionString" {
  name         = "servicebus_queue_connection_string"
  value        = azurerm_servicebus_queue_authorization_rule.serviceBusQueueAuthorizationRule.primary_connection_string
  key_vault_id = var.key_vault_id
}