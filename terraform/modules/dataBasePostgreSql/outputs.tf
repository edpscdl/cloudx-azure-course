output "env" {
  value = {
    "POSTGRESQL_CONNECTION_STRING" : join("", [
      "postgresql://",
      azurerm_postgresql_flexible_server.postgresql.administrator_login,
      ":",
      azurerm_postgresql_flexible_server.postgresql.administrator_password,
      "@",
      azurerm_postgresql_flexible_server.postgresql.fqdn,
      ":5432/",
      azurerm_postgresql_flexible_server_database.petstoredb.name
    ])
  }
}