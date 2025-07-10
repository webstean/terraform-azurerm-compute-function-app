variable "dns_zone_name" {
  type        = string
  sensitive   = false
  #default     = "example.com"
  description = <<DESCRIPTION
This variable provides the name public DNS zones to of an existing controls the whether or not Microsoft telemetry is enabled for the AVM modules, that modeule will call.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
The default is true.
DESCRIPTION
}


variable "enable_telemetry" {
  type        = bool
  sensitive   = false
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not Microsoft telemetry is enabled for the AVM modules, that modeule will call.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
The default is true.
DESCRIPTION
}

variable "user_managed_id" {
  description = <<CONTENT
The Entra ID / Azure Managed Identity that will give access to this resource.
Note, that Managed Identities can be created in either Entra ID (azuread_application) or Azure ()
Unless you need a secret for things, like external authentication, then you should use the Azure variety.
This module only support user-assigned managed identities, not system-assigned managed identities.
CONTENT
  type        = string
  validation {
    condition = can(regex("^/subscriptions/[a-f0-9-]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$", var.user_managed_id))
    error_message = "The managed identity ID must be a valid ARM ID of a user-assigned identity."
  }
    validation {
    condition     = length(var.user_managed_id) > 0
    error_message = "The variable location cannot be blank."
  }
}

variable "entra_group_id" {
  description = <<CONTENT
The existing Entra ID Workforce group id (a UUID) that will be given full-ish permissions to the resource.
This is intended for humans, not applications, so that they can access and perform some manage the resources.
One of the intention of this module, is to only allow very limit admin access, so they everything can be managed by the module. (ie by code)
Therefore you'll tpyically see that reosurce creates won't give high-level priviledge like Owner, Contributor to users.
CONTENT
  type        = string
  validation {
    condition = can(regex("^([a-fA-F0-9]{8}\\-[a-fA-F0-9]{4}\\-[a-fA-F0-9]{4}\\-[a-fA-F0-9]{4}\\-[a-fA-F0-9]{12})$", var.entra_group_id))
    error_message = "The group ID must be a valid UUID (e.g., 3c318d10-76b5-4c4b-8c8d-5b56e3abf44d)."
  }
  validation {
    condition     = length(var.entra_group_id) > 0
    error_message = "The variable location cannot be blank."
  }
}

variable "location_key" {
  description = <<CONTENT
The Azure location where the resource is to be deployed into. This is a key into the local.regions map (see locals.tf), which contains the applicable Azure region information.
The local.tf is used to map the location_key to the actual Azure region name, so that it can be used in the azurerm/azapi providers.
Unless you are using Australian regions, then you will need to customise the local.regions map to include your region amd alter the validation statements below, since they initially only support the Australia regions (australieast, australiasoutheast, australiacentral)
CONTENT
  type        = string
  default     = "australiaeast"
  validation {
    condition     = length(var.location_key) > 0
    error_message = "The variable location cannot be blank."
  }
  validation { ## change this to support other regions, you will also need to update the local.regions map
    condition     = contains(["australiaeast", "australsoutheast", "australiacentral", "australiacentral2"], var.location_key)
    error_message = "The varible environment must be only one of : australiaeast, australiasoutheast, australiacentral or australiacentral2"
  }
} // usage: local.regons[var.location_key].name  etc...

variable "application_name" {
  description = <<CONTENT
(Required) application_name (freeform) so we can tell what each resource is being used for
This should be a readily recongnisable name for you organisation, and is intended to be a large group of resources that comprise that application.
A common mistake with Azure (and other clouds), is creating too many "applications", like spliting thing into integration, website, database etc...
This usually just makes it harder to manage, so we recommend that you create a single application for each "application" that you are deploying.
Unlike what you may have experience on-premises, put the components like a frontend and database in the same namespace (like as application) you can still every securely separate them from both a security and opertational perspecitve.
The default is "main". Another good options would be "default" but even better would be your internal application name.
CONTENT
  sensitive   = false
  type        = string
  default     = "main"
  validation {
    error_message = <<CONTENT
The variable "application_name" must be between 3 and 6 characters in length and may only contain numbers and lowercase letters only."
CONTENT
    condition = (
      length(var.application_name) > 2 &&
      length(var.application_name) < 12 &&
      can(regex("[a-z.*]|[0-9]", var.application_name))
    )
  }
}

variable "project_name" { 
  description = <<CONTENT
(Required) project_name (freeform) is used in special cases, where you want to deploy two or more applications, with the same name in the same landing zone.
This would be usualy, typically you would only deploy the application once per landing zone, once in UAT, once in DEV and once in SIT etc..
However, sometimes in DEV for example, you need to support multiple developer teams, working on the same code or different parts of the project and they historically clash.
The default is "default" and we recommend you pick a project_name and stick to the same one. 
It should only be changed, when in the special case of deploying the same app in the same landing zone more than once.
CONTENT
  sensitive   = false
  type        = string
  default     = "default"
  validation {
    error_message = <<CONTENT
The variable project_name must be between 3 and 6 characters in length and may only contain numbers and lowercase letters only."
CONTENT
    condition = (
      length(var.project_name) > 2 &&
      length(var.project_name) < 12 &&
      can(regex("[a-z.*]|[0-9]", var.project_name))
    )
  }
}

variable "landing_zone_name" {
  description = <<CONTENT
(Required) environment_name (freeform) must be one of ("core", "platform", "play", "dev", "test", "uat", "sit", "preprod", "prod", "live") so we can tell what each resource is being used for
This also coressponds to the Application Landing Zone that the resource/resources will be deployed into.
An application landing zone consist of a set of secure, compliant and container type resources, intended to support many applications, web sites and databases.
Some people in our opinion, over use landing zones and create too many of them, which makes it harder to manage.
We would suggest, you consider a landing_zone as what you might call an environment: DEV, TEST, UAT, PreProd etc...
The default is "test"
CONTENT
  sensitive   = false
  type        = string
  default     = "test"
  validation {
    error_message = <<CONTENT
The variable landing_zone_name must be between 3 and 6 characters in length and may only contain numbers and lowercase letters only."
CONTENT
    condition = (
      length(var.landing_zone_name) > 2 &&
      length(var.landing_zone_name) < 7 &&
      can(regex("[a-z.*]|[0-9]", var.landing_zone_name))
    )
  }
  validation {
    error_message = <<CONTENT
The name of Application Landing Zone (sometimes known as an environment) and it must be one of: "core", "platform", "dev", "test", "uat", "sit", "preprod", "prod" or "live"
CONTENT
    condition     = contains(["core", "platform", "play", "dev", "test", "uat", "sit", "preprod", "prod", "live"], var.landing_zone_name)
  }
}

variable "sku_name" {
  description = <<CONTENT
(Required) The sku_name (only specific values) of the resource to be created (free, basic, standard, premium or isolated)
The higher the sku, the more capabilities such as high availability and auto scalling are available.
These modules, determine which sku_name corresponds to which actual Azure SKU, that you would like to deploy.
Obviously, this is subject to opinion, so whilst we are configdent our choices work well in most environments, you are free to adjust this module to so that you can use the same sku_name across all modules.
The higher end skus (premium, isolated) are typically very expensive and totaly overkill for most applications.
Note: The free sku is only applicable to some resources and in some cases the resources created with the "free" sku may not actually be free, but should be very minimal cost.
The validation rules, only permit the use of the "free" and "basic" sku to prevent unintended consequences (ie a huge bill at the end of the month)
The module will happily create these higher SKU resource, so simply edit the validation rule (below) to leverage them.
CONTENT
  sensitive   = false
  type        = string
  default     = "free"
  validation {
    error_message = "The variable sku cannot be blank/empty string."
    condition     = length(var.sku_name) > 0
  }
  validation {
    error_message = "The variable sku_name can only be one of : free, basic, standard, premium or isolated"
    condition     = contains(["free", "basic", "standard", "premium", "isolated"], var.sku_name)
  }
  # Note: When sku_name is "free", cost must also be "free"
  # This cross-variable validation will be enforced in resource preconditions
  validation {
    error_message = "The variable sku_name can only be one of : free or basic - edit this validation rule to allow more"
    condition     = contains(["free", "basic"], var.sku_name)
  }
  # Note: When sku_name is "free", cost must also be "free"
  # This cross-variable validation will be enforced in resource preconditions
}

variable "size_name" {
  description = <<CONTENT
(Required) The size_name (only specific values) for the size of resources to be deployed.
This is an option for some resources, in addition to the SKU and the module makes decisions, which obviously just our opinion.
Feel free to adjust the module as you see fit, but we are pretty confident our resources are pretty reasonable for most circumstances.
The support vaalues are "small", "medium", "large" or "x-large"
Note: The larger the size the higher the cost! These cost differecnes can be very significant, so please be careful.
Currently the validation only support the use of the "small" SKU, please edit to use the others.
CONTENT
  sensitive   = false
  type        = string
  default     = "small"
  validation {
    error_message = <<CONTENT
The variable size cannot be blank/empty string.
CONTENT
    condition     = length(var.size_name) > 0
  }
  validation {
    error_message = <<CONTENT
The varible size_name can only be one of : small, medium, large, x-large
CONTENT
    condition     = contains(["small", "medium", "large", "x-large"], var.size_name)
  }
  validation {
    error_message = <<CONTENT
If the variable sku_name is set to "free", then the variable size_name must be set to "small"
CONTENT
    condition     = var.sku_name == "free" && var.size_name == "small"
  }
  validation {
    error_message = <<CONTENT
If the variable size_name can only be set to "small", edit this validation rule to support the others
CONTENT
    condition     = contains(["small"], var.size_name)
  }
}

variable "private_endpoints_always_deployed" {
  description = <<CONTENT
(Required) private_endpoints_always_deployed (true or false) If private endpoints should be deployed, where available. This requires the sku_name to be either "premium" or "isolated"
The use of Private Endpoints is typically a hardcore requirement for hosting real data. Any PEN test will almost always want Private Endpoints everywhere.
Looking at the Azure Pricing, you might think that Private Endpoints arn't that expensive. But you would be WROMG!
You are paying for the private endpoint basically for every second that it exists. It does not take long for these costs to add up.
Unless you are hosting real data (PII and PHI) then you should not use Private Endpoints, unless you want to waste money, and for really large organisation this might not be a concern.
We have as a separate configuration option for private endpoints, because sometimes people want to test private endpoints in DEV scenarios.
Technically private endpoint should never be needed, as any Azure endpoint is protected via Entra ID authentcation/authorisation, but this is a single point of failure. If Entra was misconfigured for example, your data would potneitally be exposed.
Hence, Prviate Endpoints are a good idea, by providing a 2nd layer of security (look up the swiss cheese approach to security. But they ultimately NOT CHEAP
The default is false And, it can only be set to true, unless the sku_name is set to either "premium" or "isolated".
This is because Private Endpoints are typically only available for the higher end skus
CONTENT
  sensitive   = false
  type        = bool
  default     = false
  validation {
    error_message = <<CONTENT
Private endpoints must be deployed when the variable sku is set to either premium or isolated.
CONTENT
    condition     = var.private_endpoints_always_deployed == false && (var.sku_name != "free" || var.sku_name != "basic" || var.sku_name != "standard")
  }
  validation {
    error_message = <<CONTENT
Private endpoints can only be deployed when the variable sku is set to either premium or isolated.
CONTENT
    condition     = !var.private_endpoints_always_deployed || (var.sku_name == "premium" || var.sku_name == "isolated")
  }
}

variable "owner" {
  description = <<CONTENT
The name (preferably email address) of the resource owner for contacting in a disaster or seeking guiandance.
This is intended to assist in complying with frameworks like ITIL, COBIT, ISO27001, NIST etc...
He basically tell who is responsible for the resource, so that if when these is a problem, we know who to contact.
This will appear in the owner tag of the resource, so that it can be easily found.
CONTENT
  sensitive   = false
  type        = string
  default     = "unknown"
  validation {
    error_message = "The variable owner cannot be blank/empty string."
    condition     = length(var.owner) > 0
  }
  validation {
    error_message = "The variable owner must be more than 6 characters"
    condition     = length(var.owner) > 6
  }
  validation {
    error_message = "The variable owner must be between 6 and 25 characters and can only contain lowercase letters, numbers, hyphens and @"
    condition = (
      length(var.owner) > 6 &&
      length(var.owner) < 25 &&
      can(regex("@|[a-z.*]|[0-9]", var.owner))
    )
  }
}

variable "org_fullname" {
  description = <<CONTENT
The full name (long form) for your organisation. This is used for more , for use in descriptive and display names.
This is intended to be a human readable name, so that it can be used in the Azure
CONTENT
  sensitive   = false
  type        = string
  # default = "unknown"
  validation {
    error_message = "The variable org_fullname cannot be blank/empty string."
    condition     = length(var.org_fullname) > 0
  }
  validation {
    error_message = "The variable org_fullname must be more than 8 characters"
    condition     = length(var.org_fullname) > 8
  }
  validation {
    error_message = "The variable org_fullname must less than 25 characters and can only contain lowercase letters, numbers, hyphens and @"
    condition = (
      length(var.org_fullname) < 25 &&
      can(regex("@|[a-z.*]|[0-9]", var.org_fullname))
    )
  }
}

variable "org_shortname" {
  description = <<CONTENT
The short name (abbreviation) of the entire organisation, use for naming Azure resources.
Avoid using exotic characters, so that it can be used in all sorts of places, like DNS names, Azure resource names, Azure AD display names etc...
CONTENT
  sensitive   = false
  type        = string
  default = "org"
  validation {
    error_message = "The variable org_shortname cannot be blank/empty string."
    condition     = length(var.org_shortname) > 0
  }
  validation {
    error_message = "The variable org_shortname must be more than 3 characters"
    condition     = length(var.org_shortname) > 3
  }
  validation {
    error_message = "The variable org_shortname must be less than 25 characters and can only contain lowercase letters, numbers, hyphens and @"
    condition = (
      length(var.org_shortname) < 25 &&
      can(regex("@|[a-z.*]|[0-9]", var.org_shortname))
    )
  }
}

variable "monitoring" {
  description = <<CONTENT
Set the resource tags for all the resources, so you know what sort of monitoring the resources will be eligible for.
You can even use these tags, to only enrolled resources in certain monitoring solutions and what time alerts should be generated (anytime, office hours only).
You'll typically need to be comply with ITIL and other opertional frameworks and potentially enteprise requirements.
like Azure Monitor, Azure Log Analytics, Azure Application Insights etc...
The supported values are"24-7", "8-5" or "not-monitored"
The default is "not-monitored" which means that the resources will not be enrolled in any monitoring solution.
CONTENT
  sensitive   = false
  type        = string
  default     = "not-monitored"
  validation {
    error_message = "The variable monitoring cannot be blank/empty string/empty string."
    condition     = length(var.monitoring) > 0
  }
  validation {
    error_message = "The variable monitoring must be one 24-7, 8-5 or not-monitored"
    condition     = contains(["24-7", "8-5", "not-monitored"], var.monitoring)
  }
}

variable "cost_centre" {
  description = <<CONTENT
Cost Centre for assigning resource costs, can be be anything number or string or combination (perhaps consider using an email address
CONTENT
  sensitive   = false
  type        = string
  default     = "unknown"
  validation {
    error_message = "The variable cost_centre cannot be blank/empty string."
    condition     = length(var.cost_centre) > 0
  }
}

variable "resource_group_name" {
  description = <<CONTENT
(Required) The name of the resource group to deploy the resources into.
This resource group needs to be already exist!
This is the resource group that the resources will be deployed into and whoever is running the module 
CONTENT
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The variable resource_group_id cannot be blank."
  }
}

variable "data_pii" {
  description = <<CONTENT
(Required) data_pii (true or false) These resources will contain and/or process Personally Identifiable Information (PII)
Note, this WILL NOT enable priivate endppoints, since is conntrolled via the var.always_enable_private_endpoints variable.
However, is does enable a lot of security services, that are typcially called "Defender" by Microsoft.
These services add a lot of values, such as vulnerability scanning, threat detection, security alerts, and more.
But, they come at a cost, so you need to be aware of that.
CONTENT
  type        = string
  default     = "unknown"
  validation {
    condition     = length(var.data_pii) > 0
    error_message = "The variable data_pii cannot be blank."
  }
  validation {
    condition     = contains(["yes", "no", "unknown"], var.data_pii)
    error_message = "The variable data_pii must be one either yes or no"
  }
}

variable "data_phi" {
  description = <<CONTENT
(Required) data_phi (true or false) These resources will contain and/or process Personally Health Information (PHI)
Note, this WILL NOT enable priivate endppoints, since is conntrolled via the var.always_enable_private_endpoints variable.
However, is does enable a lot of security services, that are typcially called "Defender" by Microsoft.
These services add a lot of values, such as vulnerability scanning, threat detection, security alerts, and more.
But, they come at a cost, so you need to be aware of that.
CONTENT
  type        = string
  default     = "unknown"
  validation {
    condition     = length(var.data_phi) > 0
    error_message = "The variable data_phi cannot be blank."
  }
  validation {
    condition     = contains(["yes", "no", "unknown"], var.data_phi)
    error_message = "The variable data_phi must be one either yes or no"
  }
}

variable "subscription_id" {
  description = <<CONTENT
The Azure Subscription ID for the AzureRM, AzureAD, AzApi providers to use for their deployment.
This is the subscription where the resources will be deployed and whoever is running the module (terraform code) must have high-level permission to this subscription.
Typically this needs to be the following Azure RBAC roles: User Access Administrator and Contributor permissions.
If you using GitHub / Azure DevOps (ADO), then you should leverage OIDC to provide federation, instead of having to maintain secrets, which can be compromised.
CONTENT
  type        = string
  validation {
    condition     = length(var.subscription_id) > 0
    error_message = "The variable subscription_id cannot be blank/empty string."
  }
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", lower(var.subscription_id)))
    error_message = "The variable subscription_id must be a valid Azure subscription ID in the format 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'."
  }
}
