resource "random_string" "naming_seed" {
  length  = 7
  lower   = true
  upper   = false
  special = false
}

## combination of application and project, so we can have multiple projects with the same appplication and
## different application with in the same project.
module "naming-application" {
  for_each = { for k, v in local.regions : k => v if k == var.location_key }

  source  = "Azure/naming/azurerm"
  version = "~>0.0, < 1.0"

  suffix = [lower(var.org_shortname), lower(var.landing_zone_name), lower(var.project_name), lower(var.application_name), lower(each.value.short_name)]

  unique-seed = random_string.naming_seed.result
}
