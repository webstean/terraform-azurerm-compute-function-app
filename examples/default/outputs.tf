## Azure Subscription ID
output "subscription_id" {
  description = "Azure Subscription ID"
  value       = data.azurerm_client_config.current.subscription_id
}

output "subscription_display_name" {
  description = "Azure Subscription Display Name"
  value       = data.azurerm_subscription.current.display_name
}

output "tenant_id" {
  description = "Azure Tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "location_key" {
  description = <<CONTENT
The Azure location where the resource is to be deployed into. This is a key into the local.regions map, which contains the applicable Azure region information.
CONTENT
  value       = var.location_key
}

output "application_name" {
  description = <<CONTENT
(Required) application name (freeform) so we can tell what each resource is being used for
This also coressponds to the Application Landing Zone that the resource/resources will be deployed into.
This is ignored, when creatting an Application Landing Zone, as the name is derived from the environment_name.
CONTENT
  value       = var.application_name
}

output "project_name" {
  description = <<CONTENT
(Required) project name used to distinguish that exist to enable the rare case where you want the same application deployed
multiple times (as a different) projects within the same application landing zone.
CONTENT
  value       = var.project_name
}

output "landing_zone_name" {
  description = <<CONTENT
(Required) environment_name must be one of ("core", "platform", "play", "dev", "test", "uat", "sit", "preprod", "prod", "live") so we can tell what each resource is being used for
This also coressponds to the Application Landing Zone that the resource/resources will be deployed into.
CONTENT
  value       = var.landing_zone_name
}

output "sku_name" {
  description = <<CONTENT
(Required) The sku_name of the resource to be created (for example, free, basic, standard, premium or isolated)
The higher the sku, the more capabilities such as high availability and auto scalling are available.
CONTENT
  value       = var.sku_name
}

output "size_name" {
  description = <<CONTENT
(Required) The size of the resultant resource/resources (small, medium, large or x-large).
Note: The larger the size the higher the cost!
CONTENT
  value       = var.size_name
}

output "private_endpoints_always_deployed" {
  description = <<CONTENT
(Required) If private endpoints should be deployed, where available. Requires the cost to be set to High
CONTENT
  value       = var.private_endpoints_always_deployed
}

output "owner" {
  description = <<CONTENT
The name (preferably email address) of the resource owner for contacting in a disaster or seeking guiandance
CONTENT
  value       = var.owner
}

output "monitoring" {
  description = <<CONTENT
Set the tags, that defines what sort of monitoring the resources will be eligible for
CONTENT
  value       = var.monitoring
}

output "cost_centre" {
  description = <<CONTENT
Cost Centre for assigning resource costs, can be be anything number or string or combination (perhaps consider using an email address
CONTENT
  value       = var.cost_centre
}

output "data_pii" {
  description = <<CONTENT
(Required) These resources will contain and/or process Personally Identifiable Information (PII)
CONTENT
  value       = var.data_pii
}

output "data_phi" {
  description = <<CONTENT
(Required) These resources will contain and/or process Personally Health Information (PHI)
CONTENT
  value       = var.data_phi
}
