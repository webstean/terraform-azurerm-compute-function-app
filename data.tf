##azurerm
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azurerm_subscriptions" "current" {}
## azuread
data "azuread_client_config" "current" {}
## azapi
data "azapi_client_config" "current" {}

/*
locals {
  azurerm_id = data.azurerm_client_config.current.id
  azurerm_id = data.azurerm_subscription.current.id
  subscriptions = data.azurerm_subscriptions.current
  azuread_id = data.azuread_client_config.current.id
  azapi_id = azapi_client_config.current.id
}
*/

locals {
  zone_balancing_enabled = var.sku_name == "premium" || var.sku_name == "isolated" ? true : false
  public_access_enabled  = var.pii_data == "yes" || var.phi_data == "yes" ? false : true
}

/*
## list of all users - handy, but slow things down
data "azuread_users" "all-users" {
  return_all = true
}

## list of all groups - handy, but slow things down
data "azuread_groups" "all-groups" {
  return_all = true
}

## list of all service principals  - handy, but slow things down
data "azuread_service_principals" "all-service_principals" {
  return_all = true
*/

// only_initial - Set to true to only return the initial domain, which is your primary Azure Active Directory tenant domain.
data "azuread_domains" "initial" {
  only_initial = true
  ## Possible values include Email, Sharepoint, EmailInternalRelayOnly, OfficeCommunicationsOnline, SharePointDefaultDomain, FullRedelegation, SharePointPublic, OrgIdAuthentication, Yammer and Intune.
  supports_services = ["Email"]
}

// only_default - Set to true to only return the default domain / otherwise known as primary
data "azuread_domains" "default" {
  only_default = true
  ## Possible values include Email, Sharepoint, EmailInternalRelayOnly, OfficeCommunicationsOnline, SharePointDefaultDomain, FullRedelegation, SharePointPublic, OrgIdAuthentication, Yammer and Intune.
  supports_services = ["Email"]
}

// only_root - Set to true to only return verified root domains. Excludes subdomains and unverified domains.
data "azuread_domains" "root" {
  only_root = true
  ## Possible values include Email, Sharepoint, EmailInternalRelayOnly, OfficeCommunicationsOnline, SharePointDefaultDomain, FullRedelegation, SharePointPublic, OrgIdAuthentication, Yammer and Intune.
  supports_services = ["Email"]
}

// admin_managed - (Optional) Set to true to only return domains whose DNS is managed by Microsoft 365.
data "azuread_domains" "admin" {
  ## Possible values include Email, Sharepoint, EmailInternalRelayOnly, OfficeCommunicationsOnline, SharePointDefaultDomain, FullRedelegation, SharePointPublic, OrgIdAuthentication, Yammer and Intune.
  supports_services = ["Email"]
  admin_managed     = true
}

data "azuread_domains" "unmanaged" {
  admin_managed = false
  only_root     = true
}

#data "azuread_group" "cloud_dba" {
#  display_name = "PAG-Cloud-DBAs"
#}
#data "azuread_group" "cloud_support" {
#  display_name = "PAG-Cloud-Support"
#}
#data "azuread_group" "cloud_support_email" {
#  display_name = "Cloud-Support"
#}

/*
data "azuread_group" "dynamic_P1_license" {
  display_name = "Dynamic-All-Enabled-Users-with-atleast-EntraID-P1-license"
}
data "azuread_group" "dynamic_P2_license" {
  display_name = "Dynamic-All-Enabled-Users-with-atleast-EntraID-P2-license"
}
*/

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

/*
resource "azuread_service_principal" "azcli" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftAzureCli
  use_existing = true
}
data "azuread_service_principal" "azcli" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftAzureCli"]
}
*/

resource "azuread_service_principal" "existing-apim" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.ApiManagement
  use_existing = true
}
data "azuread_service_principal" "existing-apim" {
  client_id = data.azuread_application_published_app_ids.well_known.result["ApiManagement"]
}

/*
resource "azuread_service_principal" "existing-dynamicscrm" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.DynamicsCrm
  use_existing = true
}
data "azuread_service_principal" "existing-dynamicscrm" {
  client_id = data.azuread_application_published_app_ids.well_known.result["DynamicsCrm"]
}
*/

resource "azuread_service_principal" "existing-dynamicserp" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.DynamicsErp
  use_existing = true
}
data "azuread_service_principal" "existing-dynamicserp" {
  client_id = data.azuread_application_published_app_ids.well_known.result["DynamicsErp"]
}

#data "github_user" "current_individual" {
#  provider = github.individual
#  username = ""
#}

#data "github_user" "current_organisation" {
#  provider = github.organization
#  username = ""
#}

