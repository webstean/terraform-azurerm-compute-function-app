
terraform {
  required_version = "~>1.0, < 2.0"

  required_providers {
    alz = {
      ## Azure Landing Zones (ALZ) - generate data to allow you to simplify provisioning of your ALZ configuration.
      source  = "Azure/alz"
      version = "~>0.0, < 1.0"
    }
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
    #    msgraph = {
    #      ## Microsoft Graph - replacement for azuread *future*
    #      version = "~> 0.0, < 1.0"
    #      source  = "Microsoft/msgraph"
    #    }
    azapi = {
      ## Azure API Provider - for Azure resources that are not directly support by other providers 
      source  = "azure/azapi"
      version = "~> 2.0, < 3.0"
    }
    acme = {
      ## Letsencrypt certs etc..
      source  = "vancluever/acme"
      version = "~>2.0, < 3.0"
    }
    random = {
      ## Random provider
      source  = "hashicorp/random"
      version = "~>3.0, < 4.0"
    }
  }
}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/alz",
      ref  = "latest"
      #ref  = "2025.02.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]

  ## Configuration options
  use_oidc = true
  use_msi  = false
  use_cli  = true
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
  subscription_id           = var.subscription_id
  use_oidc                  = true
  use_aks_workload_identity = false
  use_msi                   = false
  use_cli                   = true
  enable_preflight          = true
}

provider "acme" {
  ## Configuration options
  // don't use staging endpoint, as it obviously won't work with AKV
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "random" {
  ## Configuration options
}

