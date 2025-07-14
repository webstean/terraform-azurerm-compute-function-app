
locals {
  iac_message = "Created and Managed by Terraform - do not manually change - use Terraform (IAC) instead"

  ## use this instead of variable: var.default_region
  primary_region = local.regions["australiaeast"]

  ## use this instead of variable
  preferred_region = local.regions["australiasoutheast"]
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
      time_zone_auto            = "Australia/Sydney"
      immutable_backups_enabled = false

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia Southeast"
      location                           = "australiasoutheast"
      location_shortname                 = "ase"
      zone_redundant                     = false
      zones                              = null
      default_rep_location               = "australiaeast"
      sql_maintenance_configuration_name = "SQL_AustraliaSouthEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = "ap-southeast-4"
      // Google Cloud
      gcp_region_name = "australia-southeast2"

      vnet_name          = "mel-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.3.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.3.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 3
      ## (Optional) The BGP community attribute in format <as-number>:<community-value>.
      // vnet_bgp_community   = "1234:public"
      vnet_bgp_community       = null
      private_endpoints_subnet = "private-endpoints"

      ## Custom DNS servers - no need for this, unless you have ExpressRoute/PrivateLinks
      #dns_servers        = ["8.8.8.8", "8.8.4.4"]
      ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
      ## Azure Internal DNS - 168.63.129.16

      ## Compute Defaults
      default_linux_sku         = "Standard_D2ds_v5"
      default_linux_os_simple   = "UbuntuServer"
      default_windows_sku       = "E2ads_v5"
      default_windows_os_simple = "Windows2025"

      // Storage Account Defaults
      ## BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.
      default_account_kind = "StorageV2"
      ## Standard or Premium - Premium need for NFS and/or SFTP (which is expensive - even if you don't use it!)
      default_account_tier              = "Standard"
      default_access_tier               = "Cool"
      default_account_replication_type  = "LRS"
      default_last_access_time_enabled  = true
      infrastructure_encryption_enabled = false
      min_tls_version                   = "TLS1_2"
      # hns needs to be enabled for NFS
      is_hns_enabled = "false"
      nfsv3_enabled  = "false"

      ##    lake_containers = local.lake_containers
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
      time_zone_auto            = "Australia/Sydney"
      immutable_backups_enabled = false

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia East"
      location                           = "australiaeast"
      location_shortname                 = "ae"
      zone_redundant                     = false
      zones                              = [1, 2, 3]
      default_rep_location               = "australiasoutheast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = "ap-southeast-2"
      // Google Cloud
      gcp_region_name = "australia-southeast2"

      vnet_name          = "syd-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.2.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.2.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 2
      ## (Optional) The BGP community attribute in format <as-number>:<community-value>.
      // vnet_bgp_community   = "1234:public"
      vnet_bgp_community       = null
      private_endpoints_subnet = "private-endpoints"

      ## Custom DNS servers - no need for this, unless you have ExpressRoute/PrivateLinks
      #dns_servers        = ["8.8.8.8", "8.8.4.4"]
      dns_servers = null
      ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
      ## Azure Internal DNS - 168.63.129.16

      ## Compute Defaults
      default_linux_sku         = "Standard_D2ds_v5"
      default_linux_os_simple   = "UbuntuServer"
      default_windows_sku       = "E2ads_v5"
      default_windows_os_simple = "Windows2025"

      // Storage Account Defaults
      ## BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.
      default_account_kind = "StorageV2"
      ## Standard or Premium - Premium need for NFS and/or SFTP (which is expensive - even if you don't use it!)
      default_account_tier             = "Standard"
      default_access_tier              = "Cool"
      default_account_replication_type = "LRS"
      default_last_access_time_enabled = true
      min_tls_version                  = "TLS1_2"
      # hns needs to be enabled for NFS
      is_hns_enabled = "false"
      nfsv3_enabled  = "false"

      ##      lake_containers = local.lake_containers
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
      time_zone_auto            = "Australia/Sydney"
      immutable_backups_enabled = false

      // Offical Azure location (region)
      edge_zone                          = null
      long_name                          = "(Asia Pacific) Australia Central"
      location                           = "australiacentral"
      location_shortname                 = "acl"
      zone_redundant                     = false
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
      vnet_name          = "can1-${var.landing_zone_name}-vnet01"
      vnet_address_space = ["10.22.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.22.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 22
      ## (Optional) The BGP community attribute in format <as-number>:<community-value>.
      // vnet_bgp_community   = "1234:public"
      vnet_bgp_community       = null
      private_endpoints_subnet = "private-endpoints"

      ## Custom DNS servers - no need for this, unless you have ExpressRoute/PrivateLinks
      #dns_servers        = ["8.8.8.8", "8.8.4.4"]
      dns_servers = null
      ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
      ## Azure Internal DNS - 168.63.129.16

      ## Compute Defaults
      default_linux_sku         = "Standard_D2ds_v5"
      default_linux_os_simple   = "UbuntuServer"
      default_windows_sku       = "E2ads_v5"
      default_windows_os_simple = "Windows2025"

      // Storage Account Defaults
      ## BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.
      default_account_kind = "StorageV2"
      ## Standard or Premium - Premium need for NFS and/or SFTP (which is expensive - even if you don't use it!)
      default_account_tier              = "Standard"
      default_access_tier               = "Cool"
      default_account_replication_type  = "LRS"
      default_last_access_time_enabled  = true
      infrastructure_encryption_enabled = false
      min_tls_version                   = "TLS1_2"
      # hns needs to be enabled for NFS
      is_hns_enabled = "false"
      nfsv3_enabled  = "false"

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
      immutable_backups_enabled = false

      // Offical Azure location (region)
      edge_zone                          = null
      long_name          = "(Asia Pacific) Australia Central 2"
      location           = "australiacentral2"
      location_shortname = "acl2"
      zone_redundant     = false
      zones      = null
      default_rep_location = "australiaeast"
      sql_maintenance_configuration_name = "SQL_AustraliaEast_DB_1"
      ## Static Web Apps location - limited region support
      swa_location            = "eastasia" ## "westus2", "centralus", "eastus2", "westeurope", "eastasia"

      // AWS
      aws_region_name = null
      // Google Cloud
      gcp_region_name = null

      vnet_name          = "can2-vnet01"
      vnet_address_space = ["10.222.0.0/16"]
      ## The vWAN address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
      vwan_address_space = "10.222.1.0/24"
      ## Needs to be < 255 - use telephone area code
      location_number = 3
      ## (Optional) The BGP community attribute in format <as-number>:<community-value>.
      // vnet_bgp_community   = "1234:public"
      vnet_bgp_community   = null
      private_endpoints_subnet = "private-endpoints"

      ## Custom DNS servers - no need for this, unless you have ExpressRoute/PrivateLinks
      #dns_servers        = ["8.8.8.8", "8.8.4.4"]
      dns_servers        = null
      ## Azure Internal DNS - https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
      ## Azure Internal DNS - 168.63.129.16

      ## Compute Defaults
      default_linux_sku        = "Standard_D2ds_v5"
      default_linux_os_simple        = "UbuntuServer"
      default_windows_sku      = "E2ads_v5"
      default_windows_os_simple = "Windows2025"

      // Storage Account Defaults
      ## BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.
      default_account_kind = "StorageV2"
      ## Standard or Premium - Premium need for NFS and/or SFTP (which is expensive - even if you don't use it!)
      default_account_tier              = "Standard"
      default_access_tier               = "Cool"
      default_account_replication_type  = "LRS"
      default_last_access_time_enabled  = true
      infrastructure_encryption_enabled = false
      min_tls_version                   = "TLS1_2"
      # hns needs to be enabled for NFS
      is_hns_enabled = "false"
      nfsv3_enabled  = "false"

##      lake_containers = local.lake_containers
    }
*/
  }
}

locals {
  awsregions = {
    melbourne = {
      short_name  = "melaws"
      region_name = "ap-southeast-4"
    }
    sydney = {
      short_name      = "sydaws"
      region_namename = "ap-southeast-2"
    }
    canberra1 = {
      short_name  = null
      region_name = null
    }
    canberra2 = {
      short_name    = null
      regional_name = null
    }
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
