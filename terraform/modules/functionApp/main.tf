data "azurerm_key_vault_secret" "storageAccountsAccessKey" {
  name         = var.secret_name_storage_account_access_key
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "storageAccountsConnectionString" {
  name         = var.secret_name_storage_account_connection_string
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "applicationInsightsConnectionString" {
  name         = var.secret_name_application_insights_connection_string
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryLoginServer" {
  name         = var.secret_name_container_registry_login_server
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryAdminUsername" {
  name         = var.secret_name_container_registry_admin_username
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "containerRegistryAdminPassword" {
  name         = var.secret_name_container_registry_admin_password
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "serviceBusQueueConnectionString" {
  name         = var.secret_name_servicebus_queue_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_linux_function_app" "functionApp" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_key_vault_secret.storageAccountsAccessKey.value
  service_plan_id            = var.service_plan_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  site_config {
    application_stack {
      docker {
        image_name   = "java21-func"
        image_tag    = "latest"
        registry_url = data.azurerm_key_vault_secret.containerRegistryLoginServer.value
      }
    }

    always_on = true
  }

  app_settings = merge({
    FUNCTIONS_EXTENSION_VERSION           = "~4"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
    AzureWebJobsStorage                   = data.azurerm_key_vault_secret.storageAccountsConnectionString.value
    AzureWebJobsServiceBus                = data.azurerm_key_vault_secret.serviceBusQueueConnectionString.value
    FUNCTIONS_WORKER_RUNTIME              = "java"
    APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_key_vault_secret.applicationInsightsConnectionString.value
    APPLICATIONINSIGHTS_ROLE_NAME         = lower(var.application_name)
    AZURE_MONITOR_OPENTELEMETRY_ENABLED   = "true"
    DOCKER_REGISTRY_SERVER_URL            = "https://${data.azurerm_key_vault_secret.containerRegistryLoginServer.value}"
    DOCKER_REGISTRY_SERVER_USERNAME       = data.azurerm_key_vault_secret.containerRegistryAdminUsername.value
    DOCKER_REGISTRY_SERVER_PASSWORD       = data.azurerm_key_vault_secret.containerRegistryAdminPassword.value
    SERVICEBUS_QUEUE_NAME                 = var.servicebus_queue_name
  }, var.enviroment_variables)

  https_only = true
}
