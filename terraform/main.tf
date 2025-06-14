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

module "logAnalyticsWorkspace" {
  source = "./modules/logAnalyticsWorkspace"

  name                = module.naming.log_analytics_workspace.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  depends_on = [
    module.naming,
    module.resourceGroup
  ]
}

module "applicationInsights" {
  source = "./modules/applicationInsights"

  name                = module.naming.application_insights.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  workspace_id = module.logAnalyticsWorkspace.id

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.logAnalyticsWorkspace
  ]
}

module "postgresql" {
  source = "./modules/dataBasePostgreSql"

  name                = module.naming.postgresql_database.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  database_name = "petstoredb"

  depends_on = [
    module.naming,
    module.resourceGroup
  ]
}

module "containerRegistry" {
  source = "./modules/containerRegistry"

  name                = module.naming.container_registry.name_unique
  location            = module.resourceGroup.location
  resource_group_name = module.resourceGroup.name

  depends_on = [
    module.naming,
    module.resourceGroup
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

module "containerAppPetStoreApp" {
  source = "./modules/containerApp"

  name                         = "${module.naming.container_app.name}-${local.list_web_app["petstoreapp"]}"
  resource_group_name          = module.resourceGroup.name
  application_name             = local.list_web_app["petstoreapp"]
  container_app_environment_id = module.containerAppEnvironment.id

  application_insights_connection_string = module.applicationInsights.connection_string
  container_registry_login_server        = module.containerRegistry.login_server
  container_registry_admin_username      = module.containerRegistry.admin_username
  container_registry_admin_password      = module.containerRegistry.admin_password
  enviroment_variables = merge(
    module.containerAppPetStoreOrderService.env,
    module.containerAppPetstorePetService.env,
    module.containerAppPetStoreProductService.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.containerAppPetStoreOrderService,
    module.containerAppPetstorePetService,
    module.containerAppPetStoreProductService
  ]
}

module "containerAppPetStoreOrderService" {
  source = "./modules/containerApp"

  name                         = "${module.naming.container_app.name}-${local.list_web_services["petstoreorderservice"]}"
  resource_group_name          = module.resourceGroup.name
  application_name             = local.list_web_services["petstoreorderservice"]
  container_app_environment_id = module.containerAppEnvironment.id

  application_insights_connection_string = module.applicationInsights.connection_string
  container_registry_login_server        = module.containerRegistry.login_server
  container_registry_admin_username      = module.containerRegistry.admin_username
  container_registry_admin_password      = module.containerRegistry.admin_password
  enviroment_variables = merge(
    module.containerAppPetStoreProductService.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.containerAppPetStoreProductService
  ]
}

module "containerAppPetstorePetService" {
  source = "./modules/containerApp"

  name                         = "${module.naming.container_app.name}-${local.list_web_services["petstorepetservice"]}"
  resource_group_name          = module.resourceGroup.name
  application_name             = local.list_web_services["petstorepetservice"]
  container_app_environment_id = module.containerAppEnvironment.id

  application_insights_connection_string = module.applicationInsights.connection_string
  container_registry_login_server        = module.containerRegistry.login_server
  container_registry_admin_username      = module.containerRegistry.admin_username
  container_registry_admin_password      = module.containerRegistry.admin_password
  enviroment_variables                   = merge(
    module.postgresql.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.postgresql
  ]
}

module "containerAppPetStoreProductService" {
  source = "./modules/containerApp"

  name                         = "${module.naming.container_app.name}-${local.list_web_services["petstoreproductservice"]}"
  resource_group_name          = module.resourceGroup.name
  application_name             = local.list_web_services["petstoreproductservice"]
  container_app_environment_id = module.containerAppEnvironment.id

  application_insights_connection_string = module.applicationInsights.connection_string
  container_registry_login_server        = module.containerRegistry.login_server
  container_registry_admin_username      = module.containerRegistry.admin_username
  container_registry_admin_password      = module.containerRegistry.admin_password
  enviroment_variables                   = merge(
    module.postgresql.env
  )

  depends_on = [
    module.naming,
    module.resourceGroup,
    module.applicationInsights,
    module.containerAppEnvironment,
    module.containerRegistry,
    module.postgresql
  ]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "containerAppPetStoreProductServiceFirewallRule" {
  for_each            = toset(module.containerAppPetStoreProductService.outbound_ip_addresses)

  name                = "aps-petstoreproductservice-${each.key}"
  server_id           = module.postgresql.server_id

  start_ip_address    = each.value
  end_ip_address      = each.value

  depends_on = [
    module.containerAppPetStoreProductService,
    module.postgresql
  ]
}
