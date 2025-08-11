output "name" {
  value = azurerm_linux_function_app.functionApp.name
}

output "env" {
  value = {
    "${upper(var.application_name)}_URL" : "https://${azurerm_linux_function_app.functionApp.default_hostname}"
  }
}