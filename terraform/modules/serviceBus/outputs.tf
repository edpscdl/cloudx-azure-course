output "queue_name" {
  value = azurerm_servicebus_queue.serviceBusQueue.name
}

output "secret_name_queue_connection_string" {
  value = azurerm_servicebus_queue_authorization_rule.serviceBusQueueAuthorizationRule.primary_connection_string
}

output "env" {
  value = {
    SERVICEBUS_NAMESPASE: azurerm_servicebus_namespace.serviceBusNamespace.name
    SERVICEBUS_PRICING_TIER: standard
  }
}
