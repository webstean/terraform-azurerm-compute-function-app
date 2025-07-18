## application module
## check the input variables are axctually valid

## mandatory
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azuread_group" "this" {
  object_id = startswith(var.entra_group_id, "/groups/") ? substr(var.entra_group_id, 8, -1) : var.entra_group_id
}

data "azuread_managed_identity" "this" {
  name                = var.user_managed_id
  resource_group_name = var.resource_group_name
}

## optional - must exist, except for the landing zone module
## only relevant if private_endpoints_always_deployed == false
data "azurerm_dns_zone" "this" {
  count              = var.private_endpoints_always_deployed ? 0 : 1
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

/*
data "azurerm_subnet" "private-endpoints" {
  name                 = var.private_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}
*/
