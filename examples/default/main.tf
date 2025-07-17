## This is an example of how to use this module
> ℹ️ To view this document in preview mode, press `Ctrl+Shift+V` or right-click and select **"Open Preview"**.

azuread_group "cloud_operators" {
  display_name     = "Landing Zone Operators"
  security_enabled = true
}

## Create an application landing zone, consisting of the following resources
## One Resource Group, One Public DNS Zone, Two User Assigned Identities, One Static Web App, One Log Analytics Workspace, plus 
## Application Insights (web), One KeyVault, One SQL Server associated to one SQL Server Elastic Pool (these are free, until you
## put a database in them), One Cosmos DB Account, Three Storage Accounts, One Virtual Network with subnets and Bastion,
## One Automation Account, One Container Registry, One ServiceBus Namespace ($$) & One App Configuration.
## Future: One Network Security Perimter, One Azure Data Factory (ADF), EventGrid, EventHub, ACA Application ($$)
module "application-landing-zone" {
  source  = "webstean/application-landing-zone/azurerm"
  version = "~>0.0, < 1.0"

  ## Identity
  entra_group_id    = data.azuread_group.cloud_operators.id

  ## Naming
  landing_zone_name = "play"
  dns_zone_name     = format("%s.lz.%s", var.landing_zone_name, data.azuread_domains.default.domains[0].domain_name)

  ## Location
  subscription_id   = data.azurerm_client_config.current.subscription_id
  location_key      = "australiaeast"                 ## other options are: australiasoutheast, australiacentral

  ## Sizing
  sku_name          = "free"                          ## other options are: basic, standard, premium or isolated
  size_name         = "small"                         ## other options are: medium, large or x-large

  ## Security
  private_endpoints_always_deployed = false           ## other option is: true
  pii_data                          = "no"            ## other option is: unknown, yes. If yes, a whole bunch of security features will be turned on ($$)
  phi_data                          = "no"            ## other option is: unknown, yes. If yes, a whole bunch of security features will be turned on ($$)

  ## Tags
  owner_service                     = "tbd"           ## freeform text, business owner  - email address
  owner_tech                        = "tbd"           ## freeform text, technlogy owner - email address, this where alerts will go  
  cost_centre                       = "unknown"       ## from the accountants, its the owner's cost centre. Freeform text
  monitoring                        = "not-monitored" ## other options are: 24-7 or 8-5
}

module "function_app" {
  source  = "webstean/compute-function-app/azurerm"
  version = "~>0.0, < 1.0"

  ## Identity
  entra_group_id      = azuread_group.cloud_operators.id
  user_managed_id     = module.application-landing-zone.user_managed_id
  
  ## Naming
  landing_zone_name   = module.application-landing-zone.landing_zone_name
  project_name        = "main"
  application_name    = "webstean"
  dns_zone_name       = module.application-landing-zone.dns_zone_name

  ## SKUs and Sizes
  sku_name            = module.application-landing-zone.sku_name
  size_name           = module.application-landing-zone-name.size_name

  ## Location
  subscription_id     = module.application-landing-zone.subscription_id
  location_key        = module.application-landing-zone-name.location_key
  resource_group_name = module.application-landing-zone.resource_group_name // use the one supplied by the landing zone, or create you own

  ## Tags
  owner               = module.application-landing-zone.owner
  cost_centre         = module.application-landing-zone.cost_centre
  monitoring          = module.application-landing-zone.monitoring

  ## Specific to Azure Functions    
  runtime            = "python" ## supported runtimes are: python, nodejs, .net, java, powershell, custom. Defaults to powershell

}
---
## License

Distributed under the Mozilla Public License Version 2.0 License. See [LICENSE](./LICENSE) for more information.

