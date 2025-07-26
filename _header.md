# Andrew's Terraform module for creating an Azure Function App
Function as a Service (FaaS) with Azure, you'll need to specify runtime, such as support python, etc.. The default is "powershell"

[GitHub Repository](https://github.com/webstean/terraform-azurerm-compute-function-app)

[Terraform Registry for this module](https://github.com/webstean/terraform-azurerm-compute-function-app)

[Terraform Registry Home - my other modules](https://registry.terraform.io/namespaces/webstean)


[![Python][terraform-shield]][tf-version]
[![Latest][version-shield]][release-url]
[![Tests][test-shield]][test-url]
[![License][license-shield]][license-url]
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url] -->  

This module is intended to be an **example** of how you can use Terraform Azure modules in a enterprise like environment.

> [!IMPORTANT]
> This module is **NOT** intended to be used directly. You should fork them and then customise to your own purposes.
>

> [!NOTE]
> At the moment, these modules only support deployment into the Australia regions (australiaeast, australiasoutheast, australiacentral)
> And, they don't support any value for the SKU variable other than "free", this is to avoid the deployment of super expensive resources.
> Plus, the variable: private_endpoints_always_deployed must be false, to prevent Private Endpoint from being created and costing you money.
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
## License

Distributed under the Mozilla Public License Version 2.0 License. See [LICENSE](./LICENSE) for more information.

