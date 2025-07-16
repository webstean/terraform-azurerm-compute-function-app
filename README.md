<!-- BEGIN_TF_DOCS -->
# Andrew's Terraform module for creating an Azure Function App
Function as a Service (FaaS) with Azure, you'll need to specify runtime, such as support python, etc.. The default is "powershell"

[GitHub Repository](https://github.com/webstean/terraform-azurerm-compute-function-app)

[Terraform Registry for this module](https://github.com/webstean/terraform-azurerm-compute-function-app)

[Terraform Registry Home - my other modules](https://registry.terraform.io/namespaces/webstean)

This module is intended to be an **example** of how you can use Terraform Azure modules in a enterprise like environment.

> [!IMPORTANT]
> This module is **NOT** intended to be used directly. You should fork them and then customise to your own purposes.
>

> [!INFO]
> At the moment, these modules only support deployment into the Australia regions (australiaeast, australiasoutheast, australiacentral)
> And, they don't support any value for the SKU variable other than "free", this is to avoid the deployment of super expensive resources.
> Plus, the variable: private\_endpoints\_always\_deployed must be false, to prevent Private Endpoint from being created and costing you money.
>
> You'll need to fork and customise files like region.tf, main.tf, variables.tf and redeploy into your own Terraform repository (public or private)

The real work is done by the Microsoft supplied and supported **Azure Verified Modules**. So as things change, you can rely on the Microsoft Azure Verified Modules (AVM) to do the heavy lifting for you and you can just concentre on the high-level.

For more information on **Azure Verified Modules**, please visit the [AVM portal](https://aka.ms/AVM).

This module is ultimately, just boilerplate, validation and some opinions on some of input variables into the Microsoft AVM's should be.
Although, if you don't like these choices, you can simple edit this module to suit your own needs.

Another intention of this module, is to be permit to be called via the [Azure Deployment Environment via the extensiblity model](https://learn.microsoft.com/en-us/azure/deployment-environments/how-to-configure-extensibility-model-custom-image?tabs=custom-script%2Cterraform-script%2Cprivate-registry&pivots=terraform), although is currently a work in prgoress is not currently supported.

> [!IMPORTANT]
> This modules assigns permissions to these resources it creates. Non-Humans are assigned user-assigned permission, whilst actual humans that are members of an Entra ID groups can review the resources and most of its contents.
> One goal of these modules is that changes should be done by these modules, not by manually by humans. So the assigned permsisions are very low to what you would typically see. The permissions are generally just "Reader and Data Access".
>

```shell
# Example of how to create a release of any module
gh release create v0.0.1 --title "v0.0.1" --notes "Initial release"
gh release delete v0.0.1 --cleanup-tag -yes

gh release create v0.0.2 --title "v0.0.2" --notes "New release"

```

Example:
```hcl
module "function_app" {
  source  = "webstean/compute-function-app/azurerm"
  version = "~>0.0, < 1.0"

  ## identity
  user_managed_id     = module.application_landing_zone.user_managed_id     ## services/applications
  entra_group_id      = azuread_group.cloud_operators.id                    ## humans/admin users
  ## naming
  resource_group_name = module.application_landing_zone.resource_group_name
  landing_zone_name   = "play"
  project_name        = "main"
  application_name    = "webstean"
  ## sizing
  sku_name            = "free"          ## other options are: basic, standard, premium or isolated
  size_name           = "small"         ## other options are: medium, large or x-large
  location_key        = "australiaeast" ## other supported options are: australiasoutheast, australiacentral
  private_endpoints_always_deployed = false ## other option is: true
  ## these are just use for the tags to be applied to each resource
  owner               = "tbd"           ## freeform text, but should be a person or team, email address is ideal
  cost_centre         = "unknown"       ## from the accountants, its the owner's cost centre
  ##
  subscription_id     = data.azurerm_client_config.current.subscription_id

  ## Specific to Azure Functions    
  runtime            = "python" ## supported runtimes are: python, nodejs, .net, java, powershell, custom. Defaults to powershell

}
```
---

<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0, < 2.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0, < 4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.0, < 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~>2.0, < 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0, < 4.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.existing-apim](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.existing-dynamicserp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.functionapp-storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.functionapp_python](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.functionapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_string.naming_seed](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_domains.admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_domains.default](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_domains.initial](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_domains.root](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_domains.unmanaged](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_service_principal.existing-apim](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.existing-dynamicserp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_role_definition.blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.blob_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.file_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.queue_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.queue_processor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.queue_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.queue_sender](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.reader_and_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.smb_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.smb_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.storage_defender](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.table_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.table_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_subscriptions.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | This variable provides the name public DNS zones of the landing zone | `string` | n/a | yes |
| <a name="input_entra_group_id"></a> [entra\_group\_id](#input\_entra\_group\_id) | The existing Entra ID Workforce group id (a UUID) that will be given full-ish permissions to the resource.<br/>This is intended for humans, not applications, so that they can access and perform some manage the resources.<br/>One of the intention of this module, is to only allow very limit admin access, so they everything can be managed by the module. (ie by code)<br/>Therefore you'll tpyically see that reosurce creates won't give high-level priviledge like Owner, Contributor to users. | `string` | n/a | yes |
| <a name="input_org_fullname"></a> [org\_fullname](#input\_org\_fullname) | The full name (long form) for your organisation. This is used for more , for use in descriptive and display names.<br/>This is intended to be a human readable name, so that it can be used in the Azure | `string` | n/a | yes |
| <a name="input_org_shortname"></a> [org\_shortname](#input\_org\_shortname) | The short name (abbreviation) of the entire organisation, use for naming Azure resources.<br/>Avoid using exotic characters, so that it can be used in all sorts of places, like DNS names, Azure resource names, Azure AD display names etc... | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group to deploy the resources into.<br/>This resource group needs to be already exist!<br/>This is the resource group that the resources will be deployed into and whoever is running the module | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure Subscription ID for the AzureRM, AzureAD, AzApi providers to use for their deployment.<br/>This is the subscription where the resources will be deployed and whoever is running the module (terraform code) must have high-level permission to this subscription.<br/>Typically this needs to be the following Azure RBAC roles: User Access Administrator and Contributor permissions.<br/>If you using GitHub / Azure DevOps (ADO), then you should leverage OIDC to provide federation, instead of having to maintain secrets, which can be compromised. | `string` | n/a | yes |
| <a name="input_user_managed_id"></a> [user\_managed\_id](#input\_user\_managed\_id) | The Entra ID / Azure Managed Identity that will give access to this resource.<br/>Note, that Managed Identities can be created in either Entra ID (azuread\_application) or Azure ()<br/>Unless you need a secret for things, like external authentication, then you should use the Azure variety.<br/>This module only support user-assigned managed identities, not system-assigned managed identities. | `string` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | (Required) application\_name (freeform) so we can tell what each resource is being used for<br/>This should be a readily recongnisable name for you organisation, and is intended to be a large group of resources that comprise that application.<br/>A common mistake with Azure (and other clouds), is creating too many "applications", like spliting thing into integration, website, database etc...<br/>This usually just makes it harder to manage, so we recommend that you create a single application for each "application" that you are deploying.<br/>Unlike what you may have experience on-premises, put the components like a frontend and database in the same namespace (like as application) you can still every securely separate them from both a security and opertational perspecitve.<br/>The default is "main". Another good options would be "default" but even better would be your internal application name. | `string` | `"main"` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Cost Centre for assigning resource costs, can be be anything number or string or combination (perhaps consider using an email address | `string` | `"unknown"` | no |
| <a name="input_data_phi"></a> [data\_phi](#input\_data\_phi) | (Required) data\_phi (true or false) These resources will contain and/or process Personally Health Information (PHI)<br/>Note, this WILL NOT enable priivate endppoints, since is conntrolled via the var.always\_enable\_private\_endpoints variable.<br/>However, is does enable a lot of security services, that are typcially called "Defender" by Microsoft.<br/>These services add a lot of values, such as vulnerability scanning, threat detection, security alerts, and more.<br/>But, they come at a cost, so you need to be aware of that. | `string` | `"unknown"` | no |
| <a name="input_data_pii"></a> [data\_pii](#input\_data\_pii) | (Required) data\_pii (true or false) These resources will contain and/or process Personally Identifiable Information (PII)<br/>Note, this WILL NOT enable priivate endppoints, since is conntrolled via the var.always\_enable\_private\_endpoints variable.<br/>However, is does enable a lot of security services, that are typcially called "Defender" by Microsoft.<br/>These services add a lot of values, such as vulnerability scanning, threat detection, security alerts, and more.<br/>But, they come at a cost, so you need to be aware of that. | `string` | `"unknown"` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | This variable controls whether or not Microsoft telemetry is enabled for the AVM modules, that modeule will call.<br/>For more information see https://aka.ms/avm/telemetryinfo.<br/>If it is set to false, then no telemetry will be collected.<br/>The default is true. | `bool` | `true` | no |
| <a name="input_landing_zone_name"></a> [landing\_zone\_name](#input\_landing\_zone\_name) | (Required) environment\_name (freeform) must be one of ("core", "platform", "play", "dev", "test", "uat", "sit", "preprod", "prod", "live") so we can tell what each resource is being used for<br/>This also coressponds to the Application Landing Zone that the resource/resources will be deployed into.<br/>An application landing zone consist of a set of secure, compliant and container type resources, intended to support many applications, web sites and databases.<br/>Some people in our opinion, over use landing zones and create too many of them, which makes it harder to manage.<br/>We would suggest, you consider a landing\_zone as what you might call an environment: DEV, TEST, UAT, PreProd etc...<br/>The default is "test" | `string` | `"test"` | no |
| <a name="input_location_key"></a> [location\_key](#input\_location\_key) | The Azure location where the resource is to be deployed into. This is a key into the local.regions map (see locals.tf), which contains the applicable Azure region information.<br/>The local.tf is used to map the location\_key to the actual Azure region name, so that it can be used in the azurerm/azapi providers.<br/>Unless you are using Australian regions, then you will need to customise the local.regions map to include your region amd alter the validation statements below, since they initially only support the Australia regions (australieast, australiasoutheast, australiacentral) | `string` | `"australiaeast"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Set the resource tags for all the resources, so you know what sort of monitoring the resources will be eligible for.<br/>You can even use these tags, to only enrolled resources in certain monitoring solutions and what time alerts should be generated (anytime, office hours only).<br/>You'll typically need to be comply with ITIL and other opertional frameworks and potentially enteprise requirements.<br/>like Azure Monitor, Azure Log Analytics, Azure Application Insights etc...<br/>The supported values are"24-7", "8-5" or "not-monitored"<br/>The default is "not-monitored" which means that the resources will not be enrolled in any monitoring solution. | `string` | `"not-monitored"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The name (preferably email address) of the resource owner for contacting in a disaster or seeking guiandance.<br/>This is intended to assist in complying with frameworks like ITIL, COBIT, ISO27001, NIST etc...<br/>He basically tell who is responsible for the resource, so that if when these is a problem, we know who to contact.<br/>This will appear in the owner tag of the resource, so that it can be easily found. | `string` | `"unknown"` | no |
| <a name="input_private_endpoints_always_deployed"></a> [private\_endpoints\_always\_deployed](#input\_private\_endpoints\_always\_deployed) | (Required) private\_endpoints\_always\_deployed (true or false) If private endpoints should be deployed, where available. This requires the sku\_name to be either "premium" or "isolated"<br/>The use of Private Endpoints is typically a hardcore requirement for hosting real data. Any PEN test will almost always want Private Endpoints everywhere.<br/>Looking at the Azure Pricing, you might think that Private Endpoints arn't that expensive. But you would be WROMG!<br/>You are paying for the private endpoint basically for every second that it exists. It does not take long for these costs to add up.<br/>Unless you are hosting real data (PII and PHI) then you should not use Private Endpoints, unless you want to waste money, and for really large organisation this might not be a concern.<br/>We have as a separate configuration option for private endpoints, because sometimes people want to test private endpoints in DEV scenarios.<br/>Technically private endpoint should never be needed, as any Azure endpoint is protected via Entra ID authentcation/authorisation, but this is a single point of failure. If Entra was misconfigured for example, your data would potneitally be exposed.<br/>Hence, Prviate Endpoints are a good idea, by providing a 2nd layer of security (look up the swiss cheese approach to security. But they ultimately NOT CHEAP<br/>The default is false And, it can only be set to true, unless the sku\_name is set to either "premium" or "isolated".<br/>This is because Private Endpoints are typically only available for the higher end skus | `bool` | `false` | no |
| <a name="input_private_endpoints_subnet_name"></a> [private\_endpoints\_subnet\_name](#input\_private\_endpoints\_subnet\_name) | (Required) private\_endpoints\_subnet\_name (string) the name of the Azure VNet subnet, you want the Private Endpoint created in | `string` | `null` | no |
| <a name="input_private_endpoints_vnet_name"></a> [private\_endpoints\_vnet\_name](#input\_private\_endpoints\_vnet\_name) | (Required) private\_endpoints\_subnet\_name (string) the name of the Azure VNet subnet, you want the Private Endpoint created in | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Required) project\_name (freeform) is used in special cases, where you want to deploy two or more applications, with the same name in the same landing zone.<br/>This would be usualy, typically you would only deploy the application once per landing zone, once in UAT, once in DEV and once in SIT etc..<br/>However, sometimes in DEV for example, you need to support multiple developer teams, working on the same code or different parts of the project and they historically clash.<br/>The default is "default" and we recommend you pick a project\_name and stick to the same one. <br/>It should only be changed, when in the special case of deploying the same app in the same landing zone more than once. | `string` | `"default"` | no |
| <a name="input_size_name"></a> [size\_name](#input\_size\_name) | (Required) The size\_name (only specific values) for the size of resources to be deployed.<br/>This is an option for some resources, in addition to the SKU and the module makes decisions, which obviously just our opinion.<br/>Feel free to adjust the module as you see fit, but we are pretty confident our resources are pretty reasonable for most circumstances.<br/>The support vaalues are "small", "medium", "large" or "x-large"<br/>Note: The larger the size the higher the cost! These cost differecnes can be very significant, so please be careful.<br/>Currently the validation only support the use of the "small" SKU, please edit to use the others. | `string` | `"small"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) The sku\_name (only specific values) of the resource to be created (free, basic, standard, premium or isolated)<br/>The higher the sku, the more capabilities such as high availability and auto scalling are available.<br/>These modules, determine which sku\_name corresponds to which actual Azure SKU, that you would like to deploy.<br/>Obviously, this is subject to opinion, so whilst we are configdent our choices work well in most environments, you are free to adjust this module to so that you can use the same sku\_name across all modules.<br/>The higher end skus (premium, isolated) are typically very expensive and totaly overkill for most applications.<br/>Note: The free sku is only applicable to some resources and in some cases the resources created with the "free" sku may not actually be free, but should be very minimal cost.<br/>The validation rules, only permit the use of the "free" and "basic" sku to prevent unintended consequences (ie a huge bill at the end of the month)<br/>The module will happily create these higher SKU resource, so simply edit the validation rule (below) to leverage them. | `string` | `"free"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | (Required) application name (freeform) so we can tell what each resource is being used for<br/>This also coressponds to the Application Landing Zone that the resource/resources will be deployed into.<br/>This is ignored, when creatting an Application Landing Zone, as the name is derived from the environment\_name. |
| <a name="output_cost_centre"></a> [cost\_centre](#output\_cost\_centre) | Cost Centre for assigning resource costs, can be be anything number or string or combination (perhaps consider using an email address |
| <a name="output_data_phi"></a> [data\_phi](#output\_data\_phi) | (Required) These resources will contain and/or process Personally Health Information (PHI) |
| <a name="output_data_pii"></a> [data\_pii](#output\_data\_pii) | (Required) These resources will contain and/or process Personally Identifiable Information (PII) |
| <a name="output_landing_zone_name"></a> [landing\_zone\_name](#output\_landing\_zone\_name) | (Required) environment\_name must be one of ("core", "platform", "play", "dev", "test", "uat", "sit", "preprod", "prod", "live") so we can tell what each resource is being used for<br/>This also coressponds to the Application Landing Zone that the resource/resources will be deployed into. |
| <a name="output_location_key"></a> [location\_key](#output\_location\_key) | The Azure location where the resource is to be deployed into. This is a key into the local.regions map, which contains the applicable Azure region information. |
| <a name="output_monitoring"></a> [monitoring](#output\_monitoring) | Set the tags, that defines what sort of monitoring the resources will be eligible for |
| <a name="output_owner"></a> [owner](#output\_owner) | The name (preferably email address) of the resource owner for contacting in a disaster or seeking guiandance |
| <a name="output_private_endpoints_always_deployed"></a> [private\_endpoints\_always\_deployed](#output\_private\_endpoints\_always\_deployed) | (Required) If private endpoints should be deployed, where available. Requires the cost to be set to High |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | (Required) project name used to distinguish that exist to enable the rare case where you want the same application deployed<br/>multiple times (as a different) projects within the same application landing zone. |
| <a name="output_size_name"></a> [size\_name](#output\_size\_name) | (Required) The size of the resultant resource/resources (small, medium, large or x-large).<br/>Note: The larger the size the higher the cost! |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | (Required) The sku\_name of the resource to be created (for example, free, basic, standard, premium or isolated)<br/>The higher the sku, the more capabilities such as high availability and auto scalling are available. |
| <a name="output_subscription_display_name"></a> [subscription\_display\_name](#output\_subscription\_display\_name) | Azure Subscription Display Name |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure Subscription ID |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure Tenant ID |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_functionapp_appservice"></a> [functionapp\_appservice](#module\_functionapp\_appservice) | Azure/avm-res-web-serverfarm/azurerm | ~>0.0, < 1.0 |
| <a name="module_functionapp_python"></a> [functionapp\_python](#module\_functionapp\_python) | Azure/avm-res-web-site/azurerm | ~>0.0, < 1.0 |
| <a name="module_naming-application"></a> [naming-application](#module\_naming-application) | Azure/naming/azurerm | ~>0.0, < 1.0 |
| <a name="module_storage-functionapp"></a> [storage-functionapp](#module\_storage-functionapp) | webstean/storage-account/azurerm | ~>0.0, < 1.0 |

---

Generated with [terraform-docs](https://terraform-docs.io/)
<!-- END_TF_DOCS -->