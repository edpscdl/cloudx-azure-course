data "http" "myip" {
  url = "http://whatismyip.akamai.com"
}

resource "random_password" "admin_password" {
  length      = 12
  lower       = true
  numeric     = true
  upper       = true
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

locals {
  administrator_login    = replace("${var.database_name}admin", "[^a-zA-Z0-9]", "")
  administrator_password = random_password.admin_password.result
  myip                   = chomp(data.http.myip.response_body)
}

resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name               = "B_Standard_B1ms"
  storage_mb             = "32768"
  version                = "16"
  administrator_login    = local.administrator_login
  administrator_password = local.administrator_password

  zone                   = "1"

  create_mode = "Default"
}

resource "azurerm_postgresql_flexible_server_database" "petstoredb" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgresql.id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_clientip" {
  name             = "${var.name}-owner"
  start_ip_address = local.myip
  end_ip_address   = local.myip
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
}
