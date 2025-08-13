module "petStoreNaming" {
  source = "Azure/naming/azurerm"
  suffix = ["ps"]
}

# module "resourceGroup" {
#   source = "./modules/resourceGroup"
#
#   # name     = module.petStoreNaming.resource_group.name_unique
#   name     = var.main_resource_group_name
#   location = "centralus"
#
#   depends_on = [
#     module.petStoreNaming
#   ]
# }

data "azurerm_resource_group" "petStoreResourceGroup" {
  name = var.main_resource_group_name
}

module "petStoreUserAssignedIdentity" {
  source = "./modules/azurerm/rmUserAssignedIdentity"

  name                = module.petStoreNaming.user_assigned_identity.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  depends_on = [
    module.petStoreNaming
  ]
}

module "petStoreKeyVault" {
  source = "./modules/azurerm/rmKeyVault"

  name                = module.petStoreNaming.key_vault.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  user_assigned_identity_principal_id = module.petStoreUserAssignedIdentity.principal_id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity
  ]
}

module "petStoreLogAnalyticsWorkspace" {
  source = "./modules/azurerm/rmLogAnalyticsWorkspace"

  name                = module.petStoreNaming.log_analytics_workspace.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  user_assigned_identity_id = module.petStoreUserAssignedIdentity.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity
  ]
}

module "petStoreApplicationInsights" {
  source = "./modules/azurerm/rmApplicationInsights"

  name                = module.petStoreNaming.application_insights.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  workspace_id = module.petStoreLogAnalyticsWorkspace.id
  key_vault_id = module.petStoreKeyVault.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreLogAnalyticsWorkspace,
    module.petStoreKeyVault
  ]
}

module "petStoreCosmosDb" {
  source = "./modules/azurerm/rmCosmosDbAccount"

  name                = module.petStoreNaming.cosmosdb_account.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  database_name             = "petstore"
  container_name            = "orders"
  user_assigned_identity_id = module.petStoreUserAssignedIdentity.id
  key_vault_id              = module.petStoreKeyVault.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity,
    module.petStoreKeyVault
  ]
}

module "petStoreContainerRegistry" {
  source = "./modules/azurerm/rmContainerRegistry"

  name                = module.petStoreNaming.container_registry.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  key_vault_id                        = module.petStoreKeyVault.id
  user_assigned_identity_id           = module.petStoreUserAssignedIdentity.id
  user_assigned_identity_principal_id = module.petStoreUserAssignedIdentity.principal_id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity,
    module.petStoreKeyVault
  ]
}

module "petStoreContainerAppEnvironment" {
  source = "./modules/azurerm/rmContainerAppEnvironment"

  name                = module.petStoreNaming.container_app_environment.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  log_analytics_workspace_id = module.petStoreLogAnalyticsWorkspace.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreLogAnalyticsWorkspace
  ]
}

module "petStoreServicePlan" {
  source = "./modules/azurerm/rmAppServicePlan"

  name                = module.petStoreNaming.app_service_plan.name_unique
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name
  location            = data.azurerm_resource_group.petStoreResourceGroup.location

  depends_on = [
    module.petStoreNaming
  ]
}

module "petStoreStorageAccount" {
  source = "./modules/azurerm/rmStorageAccount"

  name                = module.petStoreNaming.storage_account.name_unique
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name
  location            = data.azurerm_resource_group.petStoreResourceGroup.location

  user_assigned_identity_id = module.petStoreUserAssignedIdentity.id
  key_vault_id              = module.petStoreKeyVault.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity,
    module.petStoreKeyVault
  ]
}

module "petStoreServiceBus" {
  source = "./modules/azurerm/rmServiceBus"

  name                = module.petStoreNaming.storage_account.name_unique
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name
  location            = data.azurerm_resource_group.petStoreResourceGroup.location

  user_assigned_identity_id           = module.petStoreUserAssignedIdentity.id
  user_assigned_identity_principal_id = module.petStoreUserAssignedIdentity.principal_id
  key_vault_id                        = module.petStoreKeyVault.id

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity,
    module.petStoreKeyVault
  ]
}

module "petStoreFunctionAppPetStoreOrderReserver" {
  source = "./modules/azurerm/rmFunctionApp"

  name                                               = module.petStoreNaming.function_app.name_unique
  resource_group_name                                = data.azurerm_resource_group.petStoreResourceGroup.name
  application_name                                   = "orderitemsreserver"
  location                                           = data.azurerm_resource_group.petStoreResourceGroup.location
  service_plan_id                                    = module.petStoreServicePlan.id
  user_assigned_identity_id                          = module.petStoreUserAssignedIdentity.id
  storage_account_name                               = module.petStoreStorageAccount.name
  servicebus_queue_name                              = module.petStoreServiceBus.queue_name
  key_vault_id                                       = module.petStoreKeyVault.id
  secret_name_storage_account_access_key             = module.petStoreStorageAccount.secret_name_storage_account_access_key
  secret_name_storage_account_connection_string      = module.petStoreStorageAccount.secret_name_storage_account_connection_string
  secret_name_application_insights_connection_string = module.petStoreApplicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.petStoreContainerRegistry.secret_name_login_server
  secret_name_container_registry_admin_username      = module.petStoreContainerRegistry.secret_name_admin_username
  secret_name_container_registry_admin_password      = module.petStoreContainerRegistry.secret_name_admin_password
  secret_name_servicebus_queue_connection_string     = module.petStoreServiceBus.secret_name_queue_connection_string

  depends_on = [
    module.petStoreNaming,
    module.petStoreContainerRegistry,
    module.petStoreServicePlan,
    module.petStoreUserAssignedIdentity,
    module.petStoreStorageAccount,
    module.petStoreKeyVault,
    module.petStoreApplicationInsights
  ]
}

module "petStoreContainerAppPetStoreApp" {
  source = "./modules/azurerm/rmContainerApp"

  name                         = "${module.petStoreNaming.container_app.name}-${local.list_web_app["petstoreapp"]}"
  resource_group_name          = data.azurerm_resource_group.petStoreResourceGroup.name
  application_name             = local.list_web_app["petstoreapp"]
  container_app_environment_id = module.petStoreContainerAppEnvironment.id

  key_vault_id                                       = module.petStoreKeyVault.id
  secret_name_application_insights_connection_string = module.petStoreApplicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.petStoreContainerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.petStoreUserAssignedIdentity.id
  enviroment_variables = merge(
    module.petStoreContainerAppPetStoreOrderService.env,
    module.petStoreContainerAppPetstorePetService.env,
    module.petStoreContainerAppPetStoreProductService.env,
    module.petStoreFunctionAppPetStoreOrderReserver.env,
    {
      PETSTORE_SECURITY_ENABLED : true
      PETSTOREAPP_B2C_ENABLED : true
      PERSTORE_B2C_BASE_URI : "https://${var.b2c_application_name}.b2clogin.com/${var.b2c_application_name}.onmicrosoft.com/"
      PERSTORE_B2C_CLIENT_ID : module.b2cApplication.client_id
      PERSTORE_B2C_CLIENT_SECRET : module.b2cApplication.client_secret
      PERSTORE_B2C_USERFLOW_SIGNUP_SIGNIN : var.b2c_user_flow_signup_or_signin_name
      PERSTORE_B2C_USERFLOW_PASSWORD_RESET : var.b2c_user_flow_password_reset_name
      PERSTORE_B2C_USERFLOW_PROFILE_EDITING : var.b2c_user_flow_profile_editing_name
    }
  )

  depends_on = [
    module.petStoreNaming,
    module.petStoreApplicationInsights,
    module.petStoreContainerAppEnvironment,
    module.petStoreContainerRegistry,
    module.petStoreKeyVault,
    module.petStoreUserAssignedIdentity,
    module.petStoreContainerAppPetStoreOrderService,
    module.petStoreContainerAppPetstorePetService,
    module.petStoreContainerAppPetStoreProductService,
    module.b2cApplication
  ]
}

module "petStoreContainerAppPetStoreOrderService" {
  source = "./modules/azurerm/rmContainerApp"

  name                         = "${module.petStoreNaming.container_app.name}-${local.list_web_services["petstoreorderservice"]}"
  resource_group_name          = data.azurerm_resource_group.petStoreResourceGroup.name
  application_name             = local.list_web_services["petstoreorderservice"]
  container_app_environment_id = module.petStoreContainerAppEnvironment.id

  key_vault_id                                       = module.petStoreKeyVault.id
  secret_name_application_insights_connection_string = module.petStoreApplicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.petStoreContainerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.petStoreUserAssignedIdentity.id
  enviroment_variables = merge(
    module.petStoreContainerAppPetStoreProductService.env,
    module.petStoreKeyVault.env,
    module.petStoreUserAssignedIdentity.env,
    module.petStoreServiceBus.env
  )

  depends_on = [
    module.petStoreNaming,
    module.petStoreApplicationInsights,
    module.petStoreContainerAppEnvironment,
    module.petStoreContainerRegistry,
    module.petStoreKeyVault,
    module.petStoreUserAssignedIdentity,
    module.petStoreContainerAppPetStoreProductService
  ]
}

module "petStoreContainerAppPetstorePetService" {
  source = "./modules/azurerm/rmContainerApp"

  name                         = "${module.petStoreNaming.container_app.name}-${local.list_web_services["petstorepetservice"]}"
  resource_group_name          = data.azurerm_resource_group.petStoreResourceGroup.name
  application_name             = local.list_web_services["petstorepetservice"]
  container_app_environment_id = module.petStoreContainerAppEnvironment.id

  key_vault_id                                       = module.petStoreKeyVault.id
  secret_name_application_insights_connection_string = module.petStoreApplicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.petStoreContainerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.petStoreUserAssignedIdentity.id
  enviroment_variables = merge(
    module.petStoreKeyVault.env,
    module.petStoreUserAssignedIdentity.env
  )

  depends_on = [
    module.petStoreNaming,
    module.petStoreApplicationInsights,
    module.petStoreContainerAppEnvironment,
    module.petStoreContainerRegistry,
    module.petStoreKeyVault,
    module.petStoreUserAssignedIdentity
  ]
}

module "petStoreContainerAppPetStoreProductService" {
  source = "./modules/azurerm/rmContainerApp"

  name                         = "${module.petStoreNaming.container_app.name}-${local.list_web_services["petstoreproductservice"]}"
  resource_group_name          = data.azurerm_resource_group.petStoreResourceGroup.name
  application_name             = local.list_web_services["petstoreproductservice"]
  container_app_environment_id = module.petStoreContainerAppEnvironment.id

  key_vault_id                                       = module.petStoreKeyVault.id
  secret_name_application_insights_connection_string = module.petStoreApplicationInsights.secret_name_connection_string
  secret_name_container_registry_login_server        = module.petStoreContainerRegistry.secret_name_login_server
  user_assigned_identity_id                          = module.petStoreUserAssignedIdentity.id
  enviroment_variables = merge(
    module.petStoreKeyVault.env,
    module.petStoreUserAssignedIdentity.env
  )

  depends_on = [
    module.petStoreNaming,
    module.petStoreApplicationInsights,
    module.petStoreContainerAppEnvironment,
    module.petStoreContainerRegistry,
    module.petStoreKeyVault,
    module.petStoreUserAssignedIdentity
  ]
}

module "petStorePostgresql" {
  source = "./modules/azurerm/rmPostgresqlFlexibleServer"

  name                = module.petStoreNaming.postgresql_database.name_unique
  location            = data.azurerm_resource_group.petStoreResourceGroup.location
  resource_group_name = data.azurerm_resource_group.petStoreResourceGroup.name

  user_assigned_identity_id = module.petStoreUserAssignedIdentity.id
  key_vault_id              = module.petStoreKeyVault.id

  inbound_ip_addresses = {
    (module.petStoreContainerAppPetstorePetService.name) : module.petStoreContainerAppPetstorePetService.outbound_ip_address
    (module.petStoreContainerAppPetStoreProductService.name) : module.petStoreContainerAppPetStoreProductService.outbound_ip_address
  }

  depends_on = [
    module.petStoreNaming,
    module.petStoreUserAssignedIdentity,
    module.petStoreKeyVault,
    module.petStoreContainerAppPetstorePetService,
    module.petStoreContainerAppPetStoreProductService
  ]
}

module "b2cApplication" {
  source = "./modules/azuread/adApplication"

  applicationPasswordDisplayName = "rbac_b2c"
  applicationRegistrationDisplayName = var.b2c_application_name
}

module "b2cApplicationRedirectionUris" {
  source = "./modules/azuread/adRedirectUris"

  applicationRegistrationId = module.b2cApplication.application_registration_id
  redirectUris = ["https://${var.b2c_application_name}.b2clogin.com/${var.b2c_application_name}.onmicrosoft.com/login/oauth2/code/"]

  depends_on = [
    module.b2cApplication,
    module.petStoreContainerAppPetStoreApp
  ]
}
