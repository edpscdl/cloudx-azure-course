output "env" {
  value = {
    "${upper(var.application_name)}_URL" : "https://${azurerm_container_app.containerApp.ingress[0].fqdn}"
  }
}

output "outbound_ip_addresses" {
  value = azurerm_container_app.containerApp.outbound_ip_addresses
}