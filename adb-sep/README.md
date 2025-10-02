# Deploying Azure Databricks workspace with Storage Service Endpoints Policy enforcement

Azure Databricks since October 2025 supports assignment of [storage service endpoints policy to Databricks subnets](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/service-endpoints).  This solves a lot of problems with high costs when Azure Databricks accesses storage accounts with Databricks Runtime images or other allowed storage accounts that don't have private endpoints. 

This folder contains a Terraform code that demonstrates the usage of storage endpoint policies with Azure Databricks.

## Usage

Requires AzureRM provider with merged PR [#30762](https://github.com/hashicorp/terraform-provider-azurerm/pull/30762).

Create a `terraform.tfvars` file with the following parameters:

```hcl
subscription_id = ""
rg_name         = "" # should exist
rg_location     = "" # your location
prefix          = "sep-demo"
uc_storage_account_ids = [
  # could be specific resource, or reference to subscription or resource group as a whole
  "/subscriptions/.../resourceGroups/..../providers/Microsoft.Storage/storageAccounts/<storage_account>"
]
# address space
spoke_vnet_address_space = "10.4.0.0/16"
private_subnet_address_prefixes = ["10.4.1.0/24"]
public_subnet_address_prefixes = ["10.4.2.0/24"]
```

and then run `terraform init`, `terraform apply`.

After workspace is deployed, create a non-serverless cluster, and check NAT Gateway metrics - you should see a big amount of traffic from DBR image download. Also, you should be able to access only storage accounts specified in `uc_storage_account_ids` and DBFS storage account.

## References

* [Azure docs](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoint-policies-overview)
* [Azure Databricks docs](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/service-endpoints)

## Terraform docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_service_endpoint_storage_policy.dbfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_service_endpoint_storage_policy) | resource |
| [azurerm_subnet_service_endpoint_storage_policy.dbx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_service_endpoint_storage_policy) | resource |
| [azurerm_subnet_service_endpoint_storage_policy.uc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_service_endpoint_storage_policy) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for the resources | `string` | n/a | yes |
| <a name="input_private_subnet_address_prefixes"></a> [private\_subnet\_address\_prefixes](#input\_private\_subnet\_address\_prefixes) | Address space for private Databricks subnet | `list(string)` | n/a | yes |
| <a name="input_public_subnet_address_prefixes"></a> [public\_subnet\_address\_prefixes](#input\_public\_subnet\_address\_prefixes) | Address space for public Databricks subnet | `list(string)` | n/a | yes |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Azure Location | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Azure Resource Group Name | `string` | n/a | yes |
| <a name="input_spoke_vnet_address_space"></a> [spoke\_vnet\_address\_space](#input\_spoke\_vnet\_address\_space) | (Required) The address space for the spoke Virtual Network | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | n/a | yes |
| <a name="input_uc_storage_account_ids"></a> [uc\_storage\_account\_ids](#input\_uc\_storage\_account\_ids) | Azure Storage Account IDs for the UC Regional policy | `list(string)` | n/a | yes |
| <a name="input_databricks_workspace_name"></a> [databricks\_workspace\_name](#input\_databricks\_workspace\_name) | Name of Databricks workspace | `string` | `""` | no |
| <a name="input_dbfs_storage_account_name"></a> [dbfs\_storage\_account\_name](#input\_dbfs\_storage\_account\_name) | Azure Storage Account Name for the DBFS storage account | `string` | `""` | no |
| <a name="input_managed_resource_group_name"></a> [managed\_resource\_group\_name](#input\_managed\_resource\_group\_name) | (Optional) The name of the resource group where Azure should place the managed Databricks resources | `string` | `""` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Service endpoints to associate with subnets | `list(string)` | <pre>[<br/>  "Microsoft.EventHub",<br/>  "Microsoft.Storage",<br/>  "Microsoft.AzureActiveDirectory",<br/>  "Microsoft.Sql"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | ID of the Databricks workspace |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | URL of the Databricks workspace |
<!-- END_TF_DOCS -->
