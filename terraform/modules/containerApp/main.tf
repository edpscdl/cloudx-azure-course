data "azurerm_key_vault_secret" "applicationInsightsConnectionString" {
  name         = var.key_name_application_insights_connection_string
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryLoginServer" {
  name         = var.key_name_container_registry_login_server
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryAdminLogin" {
  name         = var.key_name_container_registry_admin_login
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryAdminPassword" {
  name         = var.key_name_container_registry_admin_password
  key_vault_id = var.key_vault_id
}

locals {
  base_env_variables = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = data.azurerm_key_vault_secret.applicationInsightsConnectionString.value,
    "APPLICATIONINSIGHTS_ROLE_NAME"              = lower(var.application_name),
    "${upper(var.application_name)}_SERVER_PORT" = "8080"
  }

  env_variables = merge(local.base_env_variables, var.enviroment_variables)
}

resource "azurerm_container_app" "containerApp" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = var.revision_mode

  secret {
    name  = var.key_name_container_registry_admin_password
    value = data.azurerm_key_vault_secret.containerRegistryAdminPassword.value
  }

  registry {
    server               = data.azurerm_key_vault_secret.containerRegistryLoginServer.value
    username             = data.azurerm_key_vault_secret.containerRegistryAdminLogin.value
    password_secret_name = var.key_name_container_registry_admin_password
  }

  ingress {
    external_enabled           = true
    transport                  = "auto"
    allow_insecure_connections = true
    target_port                = 8080

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name = var.application_name
      # image  = "${var.container_registry_login_server}/${var.application_name}:${var.application_tag}"
      image  = "mcr.microsoft.com/azurelinux/base/nginx:1"
      cpu    = "0.25"
      memory = "0.5Gi"

      dynamic "env" {
        for_each = local.env_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas = 1
    max_replicas = 3

    http_scale_rule {
      name                = "pet-http-rule"
      concurrent_requests = "10"
    }
  }
}