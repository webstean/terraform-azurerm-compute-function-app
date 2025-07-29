
locals {
  lock_kind   = "CanNotDelete" // "CanNotDelete" or "ReadOnly"
  iac_message = "Created and Managed by Terraform - no ClickOps! - use Terraform (IAC) instead"

  ## use this instead of variable: var.default_region
  primary_region = local.regions["australiaeast"]

  ## use this instead of variable
  preferred_region = local.regions["australiasoutheast"]
}

locals {
  ## https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints
  storage_private_endpoints = toset(["blob", "dfs", "file", "queue", "table", "web"])
}

locals {
  default_cors = {
    allowed_methods = [
      "*",
    ],
    allowed_origins = [
      #        "https://${data.azuread_domains.root.domains.0.domain_name}",
      #        "https://*.${var.dns_zone_name}",
      "https://*.powerapps.com",
      "https://*.powerautomate.com",
      "https://*.azure.com",
    ],
  }
  secure_cors = {
    allowed_methods = [
      "*",
    ],
    allowed_origins = [
      "https://${data.azuread_domains.root.domains.0.domain_name}",
      "https://*.${var.dns_zone_name}",
    ],
  }
}



locals {
  regions = {
    australiasoutheast = {
      // Freeform name - can be anything
      name               = "Melbourne"
      postcode           = "3000"
      short_name         = "mel"
      preferred_language = "en"
      country_code       = "AU"
      data_location      = "Australia"
      timezone           = "AUS Eastern Standard Time"
      ## for automation schedules
      time_zone_auto = "Australia/Sydney"

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia Southeast"
      region                             = "australiasoutheast"
      location                           = "australiasoutheast"
      location_shortname                 = "ase"
      zone_redundancy_available          = false
      zones                              = null
      default_rep_location               = "australiaeast"
      sql_maintenance_configuration_name = "SQL_AustraliaSouthEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = "ap-southeast-4"
      // Google Cloud
      gcp_region_name = "australia-southeast2"

      #vnet_name          = "mel-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.3.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.3.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number    = 3
      vnet_bgp_community = null ## The BGP community attribute in format <as-number>:<community-value>.

      dns_servers = null ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16

      lake_containers = local.lake_containers
    }

    australiaeast = { // needs to be the official Azure region name
      // Freeform name - can be anything
      name               = "Sydney"
      postcode           = "2000"
      short_name         = "syd"
      preferred_language = "en"
      country_code       = "AU"
      data_location      = "Australia"
      timezone           = "AUS Eastern Standard Time"
      ## for automation schedules
      time_zone_auto = "Australia/Sydney"

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia East"
      region                             = "australiaeast"
      location                           = "australiaeast"
      location_shortname                 = "ae"
      zone_redundancy_available          = true
      zones                              = [1, 2, 3]
      default_rep_location               = "australiasoutheast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = "ap-southeast-2"
      // Google Cloud
      gcp_region_name = "australia-southeast2"

      #vnet_name          = "syd-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.2.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.2.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number    = 2
      vnet_bgp_community = null ## The BGP community attribute in format <as-number>:<community-value>.

      dns_servers = null ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16

      lake_containers = local.lake_containers
    }

    australiacentral = { // needs to be the official Azure region name
      // Freeform name - can be anything
      name               = "Canberra1"
      postcode           = "2600"
      short_name         = "can1"
      preferred_language = "en"
      country_code       = "AU"
      data_location      = "Australia"
      timezone           = "AUS Eastern Standard Time"
      ## for automation schedules
      time_zone_auto = "Australia/Sydney"

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia Central"
      region                             = "australiacentral"
      location                           = "australiacentral"
      location_shortname                 = "acl"
      zone_redundancy_available          = false
      zones                              = null
      default_rep_location               = "australiaeast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = null
      // Google Cloud
      gcp_region_name = null

      // vNet (free) with 7 subnets (free)
      #vnet_name          = "can-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.22.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.22.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number    = 22
      vnet_bgp_community = null ## The BGP community attribute in format <as-number>:<community-value>.

      dns_servers = null ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16

      ##      lake_containers = local.lake_containers
    }
    /*
    australiacentral2 = { // needs to be the official Azure region name
      // Freeform name - can be anything
      name         = "Canberra2"
      postcode      = "2600"
      short_name   = "can2"
      preferred_language = "en"
      country_code = "AU"
      data_location = "Australia"
      timezone = "AUS Eastern Standard Time"
      ## for automation schedules
      time_zone_auto = "Australia/Sydney"

      // Offical Azure location (region)
      edge_zone                          = null
      long_name          = "(Asia Pacific) Australia Central 2"
      region             = "australiacentral2"
      location           = "australiacentral2"
      location_shortname = "acl2"
      zone_redundancy_available          = false
      zones      = null
      default_rep_location = "australiaeast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location            = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = null
      // Google Cloud
      gcp_region_name = null

      #vnet_name          = "can2-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.222.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.222.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 3
      vnet_bgp_community       = null ## The BGP community attribute in format <as-number>:<community-value>.

      dns_servers        = null

      lake_containers = local.lake_containers
    }
*/
    /*
    perth = { // needs to be the official Azure region name
      // Freeform name - can be anything
      name               = "Perth"
      postcode           = "6000"
      short_name         = "per"
      preferred_language = "en"
      country_code       = "AU"
      data_location      = "Australia"
      timezone           = "AUS Western Standard Time"
      ## for automation schedules
      time_zone_auto            = "Australia/Perth"

      // Offical Azure location (region)
      edge_zone                          = "perth"
      long_name                          = "(Asia Pacific) Australia East"
      region                             = "australiaeast"
      location                           = "australiaeast"
      location_shortname                 = "ae"
      zone_redundancy_available          = true
      zones                              = null
      default_rep_location               = "australiasoutheast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = "ap-southeast-2"
      // Google Cloud
      gcp_region_name = "australia-southeast2"

      vnet_name          = "per-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.6.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.6.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 6
      vnet_bgp_community       = null ## The BGP community attribute in format <as-number>:<community-value>.

      dns_servers = null ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16

      lake_containers = local.lake_containers
    }
*/



  }
}

locals {
  lake_containers = {
    raw        = "raw"
    curated    = "curated"
    normalised = "normalised"
  }
  region_lake_containers = {
    for region_key, region_value in local.regions : region_key => local.lake_containers
  }
}
output "region_lake_containers" {
  value = local.region_lake_containers
}