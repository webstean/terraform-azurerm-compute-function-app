## application module
## check the input variables are actually valid

## this has to already exist, you cannot create it here
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azuread_group" "this" {
  object_id = startswith(var.entra_group_pag_id, "/groups/") ? substr(var.entra_group_pag_id, 8, -1) : var.entra_group_pag_id
}

data "azurerm_user_assigned_identity" "graph" {
  name                = var.user_assigned_identity_graph_name
  resource_group_name = var.resource_group_name
}
data "azurerm_user_assigned_identity" "lz" {
  name                = var.user_assigned_identity_landing_zone_name
  resource_group_name = var.resource_group_name
}

data "azurerm_dns_zone" "this" {
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
