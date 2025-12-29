# Spoke VNet Module

Creates a spoke virtual network with VNet peering to a hub, Private Link subnet, Network Security Group, and route table for Databricks workspaces.

## Usage

```hcl
module "dev_vnet" {
  source                  = "../modules/spoke-vnet"
  resource_group_name     = azurerm_resource_group.dev.name
  resource_group_location = azurerm_resource_group.dev.location
  vnet_name               = "dev-vnet"
  vnet_cidrs              = ["10.1.0.0/16"]
  plsubnet_cidrs          = ["10.1.0.0/22"]
  hub_vnet_name           = "hub-vnet"
  hub_rg_name             = azurerm_resource_group.hub.name
  hub_vnet_id             = module.hub_vnet.vnet_resource_id
  tags                    = { Environment = "Dev" }
}
```

## Resources Created

- `azurerm_virtual_network` - The spoke virtual network
- `azurerm_subnet` - Private Link subnet for secure connectivity
- `azurerm_virtual_network_peering` (x2) - Bidirectional peering between hub and spoke
- `azurerm_network_security_group` - NSG for Databricks subnets
- `azurerm_route_table` - Route table for Databricks traffic
- `azurerm_route` - Routes for local VNet and default internet


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
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.localvnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.plsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.hubvnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.spokevnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hub_rg_name"></a> [hub\_rg\_name](#input\_hub\_rg\_name) | Name of the resource group holding Hub VNet | `string` | n/a | yes |
| <a name="input_hub_vnet_id"></a> [hub\_vnet\_id](#input\_hub\_vnet\_id) | Resource ID of the Hub VNet to peer with | `string` | n/a | yes |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | Name of the Hub VNet to peer with | `string` | n/a | yes |
| <a name="input_plsubnet_cidrs"></a> [plsubnet\_cidrs](#input\_plsubnet\_cidrs) | List of network ranges for Private Link Subnet | `list(string)` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of existing resource group to which deploy a Spoke VNet | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of existing resource group to which deploy a Spoke VNet | `string` | n/a | yes |
| <a name="input_vnet_cidrs"></a> [vnet\_cidrs](#input\_vnet\_cidrs) | List of network ranges for Spoke VNet | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the Spoke VNet | `string` | n/a | yes |
| <a name="input_plsubnet_name"></a> [plsubnet\_name](#input\_plsubnet\_name) | Name of Private Link Subnet to create | `string` | `"privatelink-subnet"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to attach to the Spoke VNet | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_nsg_id"></a> [db\_nsg\_id](#output\_db\_nsg\_id) | Resource ID of the created NSG |
| <a name="output_db_route_table_id"></a> [db\_route\_table\_id](#output\_db\_route\_table\_id) | Resource ID of the created route table |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the created VNet |
| <a name="output_vnet_resource_id"></a> [vnet\_resource\_id](#output\_vnet\_resource\_id) | Resource ID of the created VNet |
<!-- END_TF_DOCS -->