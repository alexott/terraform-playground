# Hub VNet Module

Creates a central hub virtual network for shared connectivity in a hub-spoke network topology.

## Usage

```hcl
module "hub_vnet" {
  source                  = "../modules/hub-vnet"
  resource_group_name     = azurerm_resource_group.hub.name
  resource_group_location = azurerm_resource_group.hub.location
  vnet_name               = "hub-vnet"
  vnet_cidrs              = ["10.0.0.0/16"]
  tags                    = { Environment = "Production" }
}
```

## Resources Created

- `azurerm_virtual_network` - The hub virtual network

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
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of existing resource group to which deploy Hub VNet | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of existing resource group to which deploy Hub VNet | `string` | n/a | yes |
| <a name="input_vnet_cidrs"></a> [vnet\_cidrs](#input\_vnet\_cidrs) | List of network ranges for Hub VNet | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the Hub VNet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to attach to the Hub VNet | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_resource_id"></a> [vnet\_resource\_id](#output\_vnet\_resource\_id) | n/a |
<!-- END_TF_DOCS -->