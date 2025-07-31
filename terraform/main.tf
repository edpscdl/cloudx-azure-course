locals {
  list_web_app = {
    petstoreapp = "petstoreapp"
  }
  list_web_services = {
    petstoreorderservice   = "petstoreorderservice"
    petstorepetservice     = "petstorepetservice"
    petstoreproductservice = "petstoreproductservice"
  }
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["ps"]
}

module "resourceGroup" {
  source = "./modules/resourceGroup"

  name     = module.naming.resource_group.name_unique
  location = "centralus"

  depends_on = [
    module.naming
  ]
}

module "userAssignedIdentity" {
  source = "./modules/userAssignedIdentity"

  name                = module.naming.user_assigned_identity.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  depends_on = [
    module.naming,
    module.resourceGroup
  ]
}

module "keyVault" {
  source = "./modules/keyVault"

  name                = module.naming.key_vault.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  user_assigned_identity_principal_id = module.userAssignedIdentity.principal_id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity
  ]
}

module "logAnalyticsWorkspace" {
  source = "./modules/logAnalyticsWorkspace"

  name                = module.naming.log_analytics_workspace.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  user_assigned_identity_id = module.userAssignedIdentity.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity
  ]
}

module "applicationInsights" {
  source = "./modules/applicationInsights"

  name                = module.naming.application_insights.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  workspace_id = module.logAnalyticsWorkspace.id
  key_vault_id = module.keyVault.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.logAnalyticsWorkspace,
    module.keyVault
  ]
}

module "cosmosdb" {
  source = "./modules/dataBaseCosmos"

  name                = module.naming.cosmosdb_account.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  database_name             = "petstore"
  container_name            = "orders"
  user_assigned_identity_id = module.userAssignedIdentity.id
  key_vault_id              = module.keyVault.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity,
    module.keyVault
  ]
}

module "containerRegistry" {
  source = "./modules/containerRegistry"

  name                = module.naming.container_registry.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  key_vault_id                        = module.keyVault.id
  user_assigned_identity_id           = module.userAssignedIdentity.id
  user_assigned_identity_principal_id = module.userAssignedIdentity.principal_id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity,
    module.keyVault
  ]
}

module "containerAppEnvironment" {
  source = "./modules/containerAppEnvironment"

  name                = module.naming.container_app_environment.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  log_analytics_workspace_id = module.logAnalyticsWorkspace.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.logAnalyticsWorkspace
  ]
}

module "servicePlanPetStore" {
  source = "./modules/appServicePlan"

  name                = module.naming.app_service_plan.name_unique
  resource_group_name = module.resourceGroup.name
  location            = module.resourceGroup.location

  depends_on = [
    module.naming,
    module.resourceGroup
  ]
}

module "storageAccountPetStore" {
  source = "./modules/storageAccount"

  name                = module.naming.storage_account.name_unique
  resource_group_name = module.resourceGroup.name
  location            = module.resourceGroup.location

  user_assigned_identity_id = module.userAssignedIdentity.id
  key_vault_id              = module.keyVault.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity,
    module.keyVault
  ]
}

module "serviceBusPetStore" {
  source = "./modules/serviceBus"

  name                = module.naming.storage_account.name_unique
  resource_group_name = module.resourceGroup.name
  location            = module.resourceGroup.location

  user_assigned_identity_id           = module.userAssignedIdentity.id
  user_assigned_identity_principal_id = module.userAssignedIdentity.principal_id
  key_vault_id                        = module.keyVault.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity,
    module.keyVault
  ]
}

module "functionAppPetStoreOrderReserver" {
  source = "./modules/functionApp"

  name                                               = module.naming.function_app.name_unique
  resource_group_name                                = module.resourceGroup.name
  application_name                                   = "orderitemsreserver"
  location                                           = module.resourceGroup.location
  service_plan_id                                    = module.servicePlanPetStore.id
  user_assigned_identity_id                          = module.userAssignedIdentity.id
  storage_account_name                               = module.storageAccountPetStore.name
  servicebus_queue_name                              = module.serviceBusPetStore.queue_name
  key_vault_id                                       = module.keyVault.id
  secret_name_storage_account_access_key             = module.storageAccountPetStore.secret_name_storage_account_access_key
  secret_name_storage_account_connection_string      = module.storageAccountPetStore.secret_name_storage_account_connection_string
  secret_name_application_insights_connection_string = module.applicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.containerRegistry.secret_name_login_server
  secret_name_container_registry_admin_username      = module.containerRegistry.secret_name_admin_username
  secret_name_container_registry_admin_password      = module.containerRegistry.secret_name_admin_password
  secret_name_servicebus_queue_connection_string     = module.serviceBusPetStore.secret_name_queue_connection_string

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.containerRegistry,
    module.servicePlanPetStore,
    module.userAssignedIdentity,
    module.storageAccountPetStore,
    module.keyVault,
    module.applicationInsights
  ]
}

module "containerAppPetStoreApp" {
  source = "./modules/containerApp"

  name                            = "${module.naming.container_app.name}-${local.list_web_app["petstoreapp"]}"
  resource_group_name             = module.resourceGroup.name
  application_name                = local.list_web_app["petstoreapp"]
  container_app_environment_id    = module.containerAppEnvironment.id

  key_vault_id                    = module.keyVault.id
  secret_name_application_insights_connection_string = module.applicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.containerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.userAssignedIdentity.id
  enviroment_variables = merge(
    module.containerAppPetStoreOrderService.env,
    module.containerAppPetstorePetService.env,
    module.containerAppPetStoreProductService.env,
    {
      PETSTORE_SECURITY_ENABLED: true
      PETSTOREAPP_B2C_BASE_URL: "https://${var.b2c_application_name}.b2clogin.com/${var.b2c_application_name}.onmicrosoft.com/"
      PERSTORE_B2C_CLIENT_ID: var.b2c_client_id
      PERSTORE_B2C_SECRET: "${var.b2c_client_secret}"
      PERSTORE_B2C_USERFLOW_SIGNUP_SIGNIN: var.b2c_user_flow_signup_or_signin_name
      PERSTORE_B2C_USERFLOW_PASSWORD_RESET: var.b2c_user_flow_password_reset_name
    }
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.keyVault,
    module.userAssignedIdentity,
    module.containerAppPetStoreOrderService,
    module.containerAppPetstorePetService,
    module.containerAppPetStoreProductService
  ]
}

module "containerAppPetStoreOrderService" {
  source = "./modules/containerApp"

  name                            = "${module.naming.container_app.name}-${local.list_web_services["petstoreorderservice"]}"
  resource_group_name             = module.resourceGroup.name
  application_name                = local.list_web_services["petstoreorderservice"]
  container_app_environment_id    = module.containerAppEnvironment.id

  key_vault_id                    = module.keyVault.id
  secret_name_application_insights_connection_string = module.applicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.containerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.userAssignedIdentity.id
  enviroment_variables = merge(
    module.containerAppPetStoreProductService.env,
    module.keyVault.env,
    module.userAssignedIdentity.env,
    module.serviceBusPetStore.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.keyVault,
    module.userAssignedIdentity,
    module.containerAppPetStoreProductService
  ]
}

module "containerAppPetstorePetService" {
  source = "./modules/containerApp"

  name                            = "${module.naming.container_app.name}-${local.list_web_services["petstorepetservice"]}"
  resource_group_name             = module.resourceGroup.name
  application_name                = local.list_web_services["petstorepetservice"]
  container_app_environment_id    = module.containerAppEnvironment.id

  key_vault_id                    = module.keyVault.id
  secret_name_application_insights_connection_string = module.applicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.containerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.userAssignedIdentity.id
  enviroment_variables = merge(
    module.keyVault.env,
    module.userAssignedIdentity.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.keyVault,
    module.userAssignedIdentity
  ]
}

module "containerAppPetStoreProductService" {
  source = "./modules/containerApp"

  name                            = "${module.naming.container_app.name}-${local.list_web_services["petstoreproductservice"]}"
  resource_group_name             = module.resourceGroup.name
  application_name                = local.list_web_services["petstoreproductservice"]
  container_app_environment_id    = module.containerAppEnvironment.id

  key_vault_id                    = module.keyVault.id
  secret_name_application_insights_connection_string = module.applicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.containerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.userAssignedIdentity.id
  enviroment_variables = merge(
    module.keyVault.env,
    module.userAssignedIdentity.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.keyVault,
    module.userAssignedIdentity
  ]
}

module "postgresql" {
  source = "./modules/dataBasePostgreSql"

  name                = module.naming.postgresql_database.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  user_assigned_identity_id = module.userAssignedIdentity.id
  key_vault_id              = module.keyVault.id

  inbound_ip_addresses = {
    (module.containerAppPetstorePetService.name) : module.containerAppPetstorePetService.outbound_ip_address
    (module.containerAppPetStoreProductService.name) : module.containerAppPetStoreProductService.outbound_ip_address
  }

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.userAssignedIdentity,
    module.keyVault,
    module.containerAppPetstorePetService,
    module.containerAppPetStoreProductService
  ]
}
