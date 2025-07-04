output "env" {
  value = {
    "${upper(var.application_name)}_URL" : "https://${azurerm_linux_function_app.functionApp.default_hostname}"
  }
}