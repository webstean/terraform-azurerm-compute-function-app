
terraform {
  ## Provider functions require Terraform 1.8 and later.
  ## Warning: versions above 1.6 are not open-source, and may cause legal issues depending on the context you are using it.
  #required_version = ">= 1.5.7" ## last version of Terraform before BSL (Business Source License)
  required_version = "~>1.0, < 2.0"

  required_providers {
#    alz = {
#      ## Azure Landing Zones (ALZ) - generate data to allow you to simplify provisioning of your ALZ configuration.
#      source  = "Azure/alz"
#      version = "~>0.0, < 1.0"
#    }
    azurerm = {
      ## Azure resource provider
      source  = "hashicorp/azurerm"
      version = "~>4.0, < 5.0"
    }
    azuread = {
      ## Azure AD (Entra ID)
      source  = "hashicorp/azuread"
      version = "~> 3.0, < 4.0"
    }
    azapi = {
      ## Azure API Provider - for Azure resources that are not directly support by neither 
      ## the azurerm nor azuread providers
      source  = "azure/azapi"
      version = "~> 2.0, < 3.0"
    }
#    github = {
#      ## GitHub provider
#      source  = "integrations/github"
#      version = "~>6.0, < 7.0"
#    }
#    azuredevops = {
#      ## Azure DevOps
#      source  = "microsoft/azuredevops"
#      version = "~>1.0, < 2.0"
#    }
#    tls = {
#      ## working with Transport Layer Security keys and certificates
#      source  = "hashicorp/tls"
#      version = "~>4.0, < 5.0"
#    }
#    powerplatform = {
#      source  = "microsoft/power-platform"
#      version = "~>3.0, < 4.0"
#    }
#    acme = {
#      ## Letsencrypt certs etc..
#      source  = "vancluever/acme"
#      version = "~>2.0, < 3.0"
#    }
    random = {
      ## Random provider
      source  = "hashicorp/random"
      version = "~>3.0, < 4.0"
    }
    local = {
      ## local files provider
      source  = "hashicorp/local"
      version = "~>2.0, < 3.0"
    }
  }
}

provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "extended"
  resource_providers_to_register = [
    "Microsoft.ContainerService",
    "Microsoft.KeyVault",
    "Microsoft.AzureTerraform",
    "Microsoft.VerifiedId",
  ]
  ## alias = "workforce"
  ## The "features" block is required for AzureRM 2.x and later
  features {

    api_management {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    template_deployment {
      delete_nested_items_during_deletion = false
    }
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
  use_oidc                  = true
  use_aks_workload_identity = false
  use_msi                   = false
  use_cli                   = true
}

# Configure the Microsoft Azure Provider
provider "azuread" {
  use_oidc                  = true
  use_aks_workload_identity = false
  use_msi                   = false
  use_cli                   = true
}

provider "azapi" {
  ## Configuration options
  subscription_id                 = var.subscription_id
  use_oidc                  = true
  use_aks_workload_identity = false
  use_msi                   = false
  use_cli                   = true
  enable_preflight          = true
}

#provider "azuredevops" {
#  # Configuration options
#  #org_service_url = "https://dev.azure.com/my-org"
#  #use_oidc        = true
#}

#provider "acme" {
#  ## Configuration options
#  // don't use staging endpoint, as it obviously won't work with AKV
#  server_url = "https://acme-v02.api.letsencrypt.org/directory"
#}

#provider "alz" {
#  ## Configuration options
#  use_oidc = true
#  use_msi  = false
#  use_cli  = false
#}

#provider "github" {
#  alias = "organization" // provider = github.organization
#  ## Configuration options
#  owner = var.git_organisation
#  token = var.git_organisation_sec
#}

#provider "github" {
#  alias = "individual" // provider = github.individual
#  ## Configuration options
#  owner = var.git_personal
#  token = var.git_personal_sec
#}

#provider "powerplatform" {
#  use_oidc = true
#}

#provider "random" {
#  ## Configuration options
#}

#provider "tls" {
#  ## Configuration options
#}

#provider "random" {}
#provider "local" {}
