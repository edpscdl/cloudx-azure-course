resource "azurerm_cosmosdb_account" "cosmosdbAccount" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  offer_type = "Standard"

  kind                             = "GlobalDocumentDB"
  public_network_access_enabled    = true
  multiple_write_locations_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmosdbDatabase" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdbAccount.name
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb_orders_container" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdbAccount.name
  database_name       = azurerm_cosmosdb_sql_database.cosmosdbDatabase.name
  partition_key_paths = ["/id"]
}

resource "azurerm_key_vault_secret" "cosmosdbAccountEndpoint" {
  name         = "cosmosdb-account-endpoint"
  value        = azurerm_cosmosdb_account.cosmosdbAccount.endpoint
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "cosmosdbPrimaryKey" {
  name         = "cosmosdb-primary-key"
  value        = azurerm_cosmosdb_account.cosmosdbAccount.primary_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "cosmosdbDatabaseName" {
  name         = "cosmosdb-database-name"
  value        = azurerm_cosmosdb_sql_database.cosmosdbDatabase.name
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "cosmosdbContainerName" {
  name         = "cosmosdb-container-name"
  value        = azurerm_cosmosdb_sql_container.cosmosdb_orders_container.name
  key_vault_id = var.key_vault_id
}
