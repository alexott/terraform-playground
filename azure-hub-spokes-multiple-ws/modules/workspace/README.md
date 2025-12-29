# Databricks Workspace Module

Deploys a VNet-injected Azure Databricks workspace with Premium SKU and secure cluster connectivity (no public IPs).

## Usage

```hcl
module "dev_ws1" {
  source                  = "../modules/workspace"
  workspace_name          = "my-databricks-ws"
  vnet_name               = module.dev_vnet.vnet_name
  resource_group_name     = azurerm_resource_group.dev.name
  resource_group_location = azurerm_resource_group.dev.location
  public_subnet_cidr      = "10.1.1.0/25"
  private_subnet_cidr     = "10.1.1.128/25"
  nsg_resource_id         = module.dev_vnet.db_nsg_id
  route_table_resource_id = module.dev_vnet.db_route_table_id
  vnet_resource_id        = module.dev_vnet.vnet_resource_id
  tags                    = { Environment = "Dev" }
}
```

## Features

- **VNet Injection**: Workspace deployed into customer-managed VNet
- **No Public IPs**: Secure cluster connectivity enabled
- **Premium SKU**: Full feature set including Unity Catalog support
- **Network Isolation**: Dedicated subnets with proper delegations

## Resources Created

- `azurerm_databricks_workspace` - Premium Databricks workspace with VNet injection
- `azurerm_subnet` (x2) - Public (host) and private (container) subnets with Databricks delegation
- `azurerm_subnet_network_security_group_association` (x2) - NSG associations for both subnets
- `azurerm_subnet_route_table_association` (x2) - Route table associations for both subnets


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.privateudr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.publicudr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nsg_resource_id"></a> [nsg\_resource\_id](#input\_nsg\_resource\_id) | Resource ID of a NSG to associate subnets with | `string` | n/a | yes |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | Network range for private (Container) subnet | `string` | n/a | yes |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | Network range for public (Host) subnet | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of existing resource group to which deploy a Databricks workspace | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of existing resource group to which deploy a Databricks workspace | `string` | n/a | yes |
| <a name="input_route_table_resource_id"></a> [route\_table\_resource\_id](#input\_route\_table\_resource\_id) | Resource ID of a route table to associate subnets with | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the Spoke VNet | `string` | n/a | yes |
| <a name="input_vnet_resource_id"></a> [vnet\_resource\_id](#input\_vnet\_resource\_id) | Resource ID of the Spoke VNet | `string` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of a Databricks workspace to create | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to attach to the Spoke VNet | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databricks_azure_workspace_resource_id"></a> [databricks\_azure\_workspace\_resource\_id](#output\_databricks\_azure\_workspace\_resource\_id) | n/a |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | n/a |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | n/a |
<!-- END_TF_DOCS -->