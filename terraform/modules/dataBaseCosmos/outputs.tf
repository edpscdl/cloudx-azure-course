output "env" {
  value = {
    COSMOSDB_ACCOUNT_ENDPOINT = azurerm_cosmosdb_account.cosmosdbAccount.endpoint
    COSMOSDB_PRIMARY_KEY = azurerm_cosmosdb_account.cosmosdbAccount.primary_key
    COSMOSDB_DATABASE_NAME = azurerm_cosmosdb_sql_database.cosmosdbDatabase.name
    COSMOSDB_CONTAINER_NAME = azurerm_cosmosdb_sql_container.cosmosdb_orders_container.name
  }
}