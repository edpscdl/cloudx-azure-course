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
      PERSTORE_B2C_BASE_URI : "https://${module.adApplicationRegistration.display_name}.b2clogin.com/${module.adApplicationRegistration.display_name}.onmicrosoft.com/"
      PERSTORE_B2C_CLIENT_ID : module.adApplicationRegistration.client_id
      PERSTORE_B2C_SECRET : module.adApplicationPassword.value
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
    module.adApplicationRegistration
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

module "petStoreEntraIdApplication" {
  source    = "./modules/azuread/adApplication"

  providers = {
    azuread = azuread.petStore
  }

  name = "heorhi_utseuski_github_actions"
  owners = [data.azurerm_client_config.current.object_id]
}

module "petStoreEntraIdServicePrincipal" {
  source = "./modules/azuread/adServicePrincipal"

  providers = {
    azuread = azuread.petStore
  }

  client_id = module.petStoreEntraIdApplication.client_id
  owners = [data.azurerm_client_config.current.object_id]
}

module "petStoreEntraIdApplicationPassword" {
  source    = "./modules/azuread/adApplicationPassword"

  providers = {
    azuread = azuread.petStore
  }

  application_id = module.petStoreEntraIdApplication.id
}

module "petStoreRoleAssigmentResourceGroup" {
  source = "./modules/azurerm/rmRoleAssignment"

  assignee = module.petStoreEntraIdServicePrincipal.object_id
  scope    = data.azurerm_resource_group.petStoreResourceGroup.id
  roles = [
    "Container Apps Contributor",
    "Web Plan Contributor",
    "Website Contributor"
  ]

  depends_on = [
    module.petStoreEntraIdApplication
  ]
}

module "petStoreRoleAssigmentContainerRegistry" {
  source = "./modules/azurerm/rmRoleAssignment"

  assignee = module.petStoreEntraIdServicePrincipal.object_id
  scope    = module.petStoreContainerRegistry.id
  roles = [
    "AcrPush",
    "Contributor"
  ]

  depends_on = [
    module.petStoreEntraIdApplication,
    module.petStoreContainerRegistry
  ]
}

module "adApplicationRegistration" {
  source    = "./modules/azuread/adApplicationRegistration"

  providers = {
    azuread = azuread.auth
  }

  display_name = var.b2c_application_name
}

module "adApplicationOwner" {
  source = "./modules/azuread/adApplicationOwner"

  providers = {
    azuread = azuread.auth
  }

  application_id = module.adApplicationRegistration.id
  owner_object_id = data.azuread_client_config.current.object_id
}

module "adServicePrincipal" {
  source = "./modules/azuread/adServicePrincipal"

  providers = {
    azuread = azuread.auth
  }

  client_id = module.adApplicationRegistration.client_id
  owners = [data.azuread_client_config.current.object_id]
}

module "adApplicationPassword" {
  source    = "./modules/azuread/adApplicationPassword"

  providers = {
    azuread = azuread.auth
  }

  application_id = module.adApplicationRegistration.id
  display_name   = "rbac"

  depends_on = [
    module.adApplicationRegistration
  ]
}

module "adApplicationRedirectUris" {
  source    = "./modules/azuread/adApplicationRedirectUris"

  providers = {
    azuread = azuread.auth
  }

  application_registration_id = module.adApplicationRegistration.id
  type                        = "Web"
  redirect_uris = [
    module.petStoreContainerAppPetStoreApp.url
  ]

  depends_on = [
    module.adApplicationRegistration
  ]
}
