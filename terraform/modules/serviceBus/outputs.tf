output "queue_name" {
  value = azurerm_servicebus_queue.serviceBusQueue.name
}

output "secret_name_queue_connection_string" {
  value = azurerm_key_vault_secret.serviceBusQueueConnectionString.name
}

output "env" {
  value = {
    SERVICEBUS_NAMESPASE: azurerm_servicebus_namespace.serviceBusNamespace.name
    SERVICEBUS_PRICING_TIER: "standard"
  }
}
