output "env" {
  value = {
    POSTGRESQL_SERVER_HOST = azurerm_postgresql_flexible_server.postgresql.fqdn
    POSTGRESQL_SERVER_PORT = "5432"
    POSTGRESQL_DATABASE_NAME = azurerm_postgresql_flexible_server_database.petstoredb.name
    POSTGRESQL_DATABASE_USERNAME = azurerm_postgresql_flexible_server.postgresql.administrator_login
    POSTGRESQL_DATABASE_PASSWORD = azurerm_postgresql_flexible_server.postgresql.administrator_password
  }
}