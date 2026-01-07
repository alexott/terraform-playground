# VNet with Databricks Workspace Module

This module creates an Azure Databricks workspace with associated networking infrastructure using RFC 6598 (Shared Address Space) IP ranges. It includes a dedicated VNet for the workspace, a separate firewall VNet, and necessary routing and security configurations.

## Overview

The module provisions:

- **Workspace VNet**: Virtual network using RFC 6598 address space (100.64.0.0/10) for the Databricks workspace
- **Databricks Workspace**: Premium SKU workspace with custom VNet injection
- **Firewall VNet**: Dedicated VNet for Azure Firewall with allow-all rules for internal routing
- **Azure Bastion**: Secure access to resources without public IPs
- **Network Security Groups**: Applied to Databricks host and container subnets
- **Route Tables**: Force all workspace traffic through the local firewall

## Architecture

### Network Layout

The module creates multiple subnets with specific purposes:

- **Host Subnet**: Databricks cluster nodes (delegated to Microsoft.Databricks/workspaces)
- **Container Subnet**: Databricks container instances (delegated to Microsoft.Databricks/workspaces)
- **Private Endpoint Subnet**: For Azure Private Endpoints
- **Utility Subnet**: General-purpose subnet for auxiliary resources
- **Bastion Subnet**: Azure Bastion service (named AzureBastionSubnet)

### Firewall VNet

A separate VNet is created specifically for routing purposes:

- **Firewall Subnet**: Azure Firewall with internal IP only (named AzureFirewallSubnet)
- **Management Subnet**: Azure Firewall management interface (named AzureFirewallManagementSubnet)
- **SNAT Configuration**: Configured with private IP ranges to prevent SNAT on internal traffic (255.255.255.255/32)

### Routing

The module implements a routing architecture where:

1. Databricks subnets route all traffic (0.0.0.0/0) to the local firewall
2. Local firewall subnet routes all traffic to the hub firewall via UDR
3. VNet peering established between workspace VNet, firewall VNet, and hub VNet

### VNet Peering

The module establishes three peering connections:

- Workspace VNet ↔ Firewall VNet
- Firewall VNet ↔ Hub VNet (provided as input)

## Key Features

### RFC 6598 Address Space

Uses the Shared Address Space (100.64.0.0/10) defined in RFC 6598, designed for carrier-grade NAT. This range avoids conflicts with:

- Public internet addresses
- Private RFC 1918 ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- Common on-premises networks

### Network Security

- **Service Delegation**: Databricks subnets are properly delegated with required actions
- **NSG Association**: Network Security Groups applied to both host and container subnets
- **Forced Tunneling**: All egress traffic routed through firewall for inspection

### Databricks Integration

- **Custom VNet Injection**: Databricks workspace uses provided subnets
- **Premium SKU**: Enables advanced features like VNet injection and Private Link
- **Managed Resource Group**: Databricks-managed resources deployed to separate RG

## Usage Example

```hcl
module "databricks_workspace" {
  source = "./modules/vnet_with_ws"
  
  rg_name     = "my-resource-group"
  rg_location = "eastus"
  name_prefix = "myorg-prod"
  
  # Firewall VNet configuration
  firewall_vnet_cidr              = "10.0.1.0/25"
  firewall_subnet_cidr            = "10.0.1.0/26"
  firewall_management_subnet_cidr = "10.0.1.64/26"
  
  # Hub network integration
  hub_vnet_id     = azurerm_virtual_network.hub.id
  hub_firewall_ip = "10.0.0.4"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Default CIDR Ranges

The module uses the following default CIDR ranges (all can be overridden):

- **VNet**: 100.64.0.0/10 (RFC 6598 range)
- **Host Subnet**: 100.64.0.0/20
- **Container Subnet**: 100.64.16.0/20
- **Private Endpoint Subnet**: 100.64.253.0/24
- **Utility Subnet**: 100.64.254.0/24
- **Bastion Subnet**: 100.64.255.0/26

## Important Notes

- **Firewall VNet CIDR**: Must not overlap with hub VNet or any peered networks. Typically use a small /25 subnet from standard private ranges
- **Management Subnet**: Required for Azure Firewall to support forced tunneling scenarios
- **SNAT Configuration**: The firewall is configured with `private_ip_ranges = ["255.255.255.255/32"]` to prevent SNAT on all traffic
- **Service Delegation**: The Databricks workspace requires specific delegation actions on host and container subnets

## Providers

This module uses the AzureRM provider and requires no additional provider configuration (inherits from root module).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_network_rule_collection.allow_all](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.bastion_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_route.firewall_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.hub_firewall_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.firewall_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route_table.hub_firewall_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.bastion_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.container_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall_management_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.host_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.utility_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.container_subnet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.host_subnet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.container_subnet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.host_subnet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.hub_firewall_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.firewall_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.firewall_vnet_to_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.hub_vnet_to_firewall_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.vnet_to_firewall_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall_management_subnet_cidr"></a> [firewall\_management\_subnet\_cidr](#input\_firewall\_management\_subnet\_cidr) | CIDR for the firewall management subnet. It's expected to be a /26 subnet | `string` | n/a | yes |
| <a name="input_firewall_subnet_cidr"></a> [firewall\_subnet\_cidr](#input\_firewall\_subnet\_cidr) | CIDR for the firewall subnet. It's expected to be a /26 subnet | `string` | n/a | yes |
| <a name="input_firewall_vnet_cidr"></a> [firewall\_vnet\_cidr](#input\_firewall\_vnet\_cidr) | CIDR for the firewall VNet. It's expected to be a /25 subnet | `string` | n/a | yes |
| <a name="input_hub_firewall_ip"></a> [hub\_firewall\_ip](#input\_hub\_firewall\_ip) | IP address for the hub firewall | `string` | n/a | yes |
| <a name="input_hub_vnet_id"></a> [hub\_vnet\_id](#input\_hub\_vnet\_id) | ID of the hub VNet | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for the name of all resources | `string` | n/a | yes |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Location of the resource group to deploy resources to | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the resource group to deploy resources to | `string` | n/a | yes |
| <a name="input_bastion_subnet_cidr"></a> [bastion\_subnet\_cidr](#input\_bastion\_subnet\_cidr) | CIDR for the bastion subnet | `string` | `"100.64.255.0/26"` | no |
| <a name="input_container_subnet_cidr"></a> [container\_subnet\_cidr](#input\_container\_subnet\_cidr) | Address CIDR for the container subnet | `string` | `"100.64.16.0/20"` | no |
| <a name="input_host_subnet_cidr"></a> [host\_subnet\_cidr](#input\_host\_subnet\_cidr) | Address CIDR for the host subnet | `string` | `"100.64.0.0/20"` | no |
| <a name="input_pe_subnet_cidr"></a> [pe\_subnet\_cidr](#input\_pe\_subnet\_cidr) | CIDR for the PE subnet | `string` | `"100.64.253.0/24"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_utility_subnet_cidr"></a> [utility\_subnet\_cidr](#input\_utility\_subnet\_cidr) | CIDR for the utility subnet | `string` | `"100.64.254.0/24"` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | Address CIDR for the virtual network | `string` | `"100.64.0.0/10"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | n/a |
| <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id) | n/a |
| <a name="output_databricks_workspace_url"></a> [databricks\_workspace\_url](#output\_databricks\_workspace\_url) | n/a |
| <a name="output_dbfs_storage_account_name"></a> [dbfs\_storage\_account\_name](#output\_dbfs\_storage\_account\_name) | n/a |
| <a name="output_firewall_subnet_address_prefixes"></a> [firewall\_subnet\_address\_prefixes](#output\_firewall\_subnet\_address\_prefixes) | n/a |
| <a name="output_firewall_vnet_id"></a> [firewall\_vnet\_id](#output\_firewall\_vnet\_id) | n/a |
<!-- END_TF_DOCS -->
