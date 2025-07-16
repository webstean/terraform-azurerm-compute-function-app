
## github_repository.github-template-create.${each.key}.name

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}


module "storage-functionapp" {
  source  = "webstean/storage-account/azurerm"
  version = "~>0.0, < 1.0"

  ## identity
  user_managed_id = var.application_landing_zone.user_managed_id
  entra_group_id  = var.azuread_group.cloud_operators.id
  ## naming
  resource_group_name = data.azurerm_resource_group.this.name
  application_name    = var.application_name
  ## sizing
  sku_name                          = "free"          ## other options are: basic, standard, premium or isolated
  size_name                         = "small"         ## other options are: medium, large or x-large
  location_key                      = "australiaeast" ## other options are: australiasoutheast, australiacentral
  private_endpoints_always_deployed = false           ## other option is: true
  ## these are just use for the tags to be applied to each resource
  owner       = "tbd"     ## freeform text, but should be a person or team, email address is ideal
  cost_centre = "unknown" ## from the accountants, its the owner's cost centre
  ##
  subscription_id = data.azurerm_client_config.current.subscription_id

  ## Specific to Azure Functions    
  storage_type             = "blob"
  storage_replication_type = "LRS"
}

locals {
  functionapp_sku                 = "FC1"         ##"S1" ## "P0v3" ## PremiumV3
  functionapp_type                = "functionapp" ## Possible values are functionapp, webapp and logicapp
  functionapp_fc1_runtime_name    = "python"      ## Possible values are node, dotnet-isolated, powershell, python, java
  functionapp_fc1_runtime_version = "3.11"        ## For Python, Possible values are 3.10, 3.11
  functionapp_os_type             = "Linux"       ## Possible values are Linux and Windows
}

/*
resource "azurerm_dns_cname_record" "functionapp" {
  name                = local.functionapp_name
  zone_name           = azurerm_dns_zone.app.name
  resource_group_name = data.azurerm_resource_group.this.name
  record              = var.application_name
  ttl                 = 300
  tags                = azurerm_resource_group.dns.tags
  lifecycle {
    ignore_changes = [tags.created]
  }
}
*/

resource "azurerm_storage_container" "functionapp" {
  name               = var.application_name
  storage_account_id = module.storage-functionapp.resource_id
}
resource "azurerm_role_assignment" "functionapp-storage" {
  for_each = azurerm_storage_container.functionapp

  principal_id         = var.user_managed_id
  scope                = module.storage-functionapp.resource_id
  role_definition_name = data.azurerm_role_definition.blob_contributor.name
}

module "functionapp_appservice" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "~>0.0, < 1.0"

  name                   = module.naming-application.app_service_plan.name_unique
  resource_group_name    = data.azurerm_resource_group.this.name
  location               = local.regions[var.location_key].location
  os_type                = local.functionapp_os_type
  sku_name               = local.functionapp_sku
  zone_balancing_enabled = local.zone_balancing_enabled

  tags = azurerm_resource_group.functionapp.tags
}

module "functionapp_python" {
  for_each = module.functionapp_appservice

  source           = "Azure/avm-res-web-site/azurerm"
  version          = "~>0.0, < 1.0"
  enable_telemetry = var.enable_telemetry

  name                = local.functionapp_name
  resource_group_name = var.resource_group_name
  location            = local.regions[var.location_key].location

  kind                  = local.functionapp_type
  fc1_runtime_name      = local.functionapp_fc1_runtime_name
  fc1_runtime_version   = local.functionapp_fc1_runtime_version
  function_app_uses_fc1 = true ## Run on the Flex Conumption 
  instance_memory_in_mb = 2048 ## Must be 2048 or 4096

  managed_identities = {
    system_assigned = false
    user_assigned_resource_ids = [
      var.user_managed_id
    ]
  }

  public_network_access_enabled = local.public_access_enabled
  #virtual_network_subnet_id         = module.virtual_network.subnet1[each.key].resource_id
  #vnet_image_pull_enabled = true

  # Uses an existing app service plan
  os_type                  = local.functionapp_os_type
  service_plan_resource_id = each.value.resource_id

  # Uses an existing storage account
  storage_account_name              = azurerm_storage_account.functionapp.name
  storage_authentication_type       = "UserAssignedIdentity"
  storage_user_assigned_identity_id = module.user_assigned_identity.resource_id
  storage_container_endpoint        = azurerm_storage_container.functionapp.id
  storage_container_type            = "blobContainer"

  //  application_insights = {
  //    workspace_resource_id = module.log_analytics_workspace.id
  //  }

  #app_settings = {
  #  WEBSITE_RUN_FROM_PACKAGE = 1
  #}

  site_config = {
    application_stack = {
      (local.functionapp_fc1_runtime_name) = {
        python_version = local.functionapp_fc1_runtime_version
      }
    }
    remote_debugging_version = "VS2022"
    #    cors = {
    #      allowed_origins = [
    #        "https://portal.azure.com",
    #        "https://preview.portal.azure.com",
    #        "https://rc.portal.azure.com",
    #      ]
    #      support_credentials = true
    #    }
  }

  tags = azurerm_resource_group.functionapp.tags
}

resource "azurerm_role_assignment" "functionapp_python" {
  for_each = module.functionapp_python

  principal_id         = module.user_assigned_identity.principal_id
  scope                = each.value.resource_id
  role_definition_name = "Contributor"
}

