output "connection_string" {
  value     = azurerm_application_insights.applicationInsights.connection_string
  sensitive = true
}