# RFC 6598 Databricks Deployment

This Terraform configuration deploys an Azure Databricks workspace with a secure hub-and-spoke network architecture using RFC 6598 (Shared Address Space) IP ranges. The deployment implements network security controls using Azure Firewall to manage egress traffic from the Databricks workspace.

## Overview

The configuration creates:

- **Hub VNet**: Central virtual network containing an Azure Firewall for egress traffic inspection and control
- **Spoke VNet (via module)**: Contains the Databricks workspace and associated resources including a dedicated firewall VNet
- **Azure Firewall Rules**: Network and application rules to control Databricks control plane connectivity
- **VNet Peering**: Connections between hub and spoke networks

## Architecture

The deployment follows a hub-and-spoke network topology:

```
Hub VNet (Standard CIDR)
  └─ Azure Firewall (with public IP)
      │
      ├─ Network Rules: Databricks control plane (webapp, metastore, eventhubs)
      └─ Application Rules: Databricks FQDNs, DBFS, SCC relay
      
Firewall VNet (RFC 6598 range)
  └─ Local Azure Firewall (allow-all for internal routing)
      └─ Routes all traffic to Hub Firewall

Workspace VNet (RFC 6598 range: 100.64.0.0/10)
  ├─ Databricks Host Subnet
  ├─ Databricks Container Subnet
  ├─ Private Endpoint Subnet
  ├─ Utility Subnet
  └─ Azure Bastion Subnet
```

## Key Features

### Network Security

- **Dual Firewall Architecture**: Hub firewall for internet egress, dedicated firewall VNet for workspace traffic routing
- **Forced Tunneling**: All workspace traffic is routed through the local firewall, which routes to the hub firewall
- **Network Isolation**: Uses RFC 6598 address space (100.64.0.0/10) for Databricks workspace to avoid conflicts with on-premises networks
- **DNS Resolution**: Dynamic resolution of Databricks service endpoints (metastore, eventhubs, SCC relay)

### Databricks Control Plane Access

The firewall rules allow connectivity to:

- **Webapp endpoints**: TCP ports 443, 8443-8451
- **Metastore**: TCP port 3306
- **Event Hubs**: TCP port 9093
- **DBFS Storage**: HTTPS access to workspace storage accounts
- **SCC Relay**: HTTPS access for Secure Cluster Connectivity
- **Additional FQDNs**: Configurable list of allowed domains

### Bastion Access

- Azure Bastion host for secure SSH/RDP access to resources in the workspace VNet
- No public IPs required on target VMs

## Usage

1. Configure required variables (see terraform-docs output below)
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the plan:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Important Notes

- **IP Addresses**: Databricks control plane IPs (webapp, metastore, eventhubs, SCC relay) must be provided based on your Azure region. Refer to [Microsoft documentation](https://learn.microsoft.com/en-us/azure/databricks/resources/ip-domain-region#control-plane-ip-addresses)
- **Firewall Policy**: Currently uses individual firewall rules. Consider migrating to Azure Firewall Policy for better management (see TODO in firewall.tf)
- **CIDR Planning**: Ensure firewall VNet CIDRs don't overlap with hub VNet or other networks

## Providers

- **azurerm** (~>4.0): Azure Resource Manager provider
- **dns**: For dynamic DNS resolution of Databricks service endpoints

## Module Dependencies

This configuration uses the local `vnet_with_ws` module to deploy the Databricks workspace and associated networking resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.0 |
| <a name="provider_dns"></a> [dns](#provider\_dns) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vnet_with_ws"></a> [vnet\_with\_ws](#module\_vnet\_with\_ws) | ./modules/vnet_with_ws | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.hub_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_application_rule_collection.application_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection) | resource |
| [azurerm_firewall_network_rule_collection.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_public_ip.hub_firewall_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.hub_firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.firewall_vnet_to_hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [dns_a_record_set.eventhubs](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |
| [dns_a_record_set.metastores](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |
| [dns_a_record_set.scc_relay](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databricks_fqdns"></a> [databricks\_fqdns](#input\_databricks\_fqdns) | List of Databricks FQDNs (storage accounts, etc.) | `list(string)` | n/a | yes |
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | List of event hubs hosts | `list(string)` | n/a | yes |
| <a name="input_hub_firewall_subnet_cidr"></a> [hub\_firewall\_subnet\_cidr](#input\_hub\_firewall\_subnet\_cidr) | CIDR for the hub firewall subnet | `string` | n/a | yes |
| <a name="input_hub_vnet_cidr"></a> [hub\_vnet\_cidr](#input\_hub\_vnet\_cidr) | CIDR for the hub VNet | `string` | n/a | yes |
| <a name="input_metastores"></a> [metastores](#input\_metastores) | List of Hive metastore hosts | `list(string)` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for the resource names | `string` | n/a | yes |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Location of the resource group to deploy resources to | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the resource group to deploy resources to | `string` | n/a | yes |
| <a name="input_scc_relay"></a> [scc\_relay](#input\_scc\_relay) | List of SCC relay hosts | `list(string)` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID to use | `string` | n/a | yes |
| <a name="input_webapp_ips"></a> [webapp\_ips](#input\_webapp\_ips) | List of webapp IPs | `list(string)` | n/a | yes |
| <a name="input_additional_allowed_fqdns"></a> [additional\_allowed\_fqdns](#input\_additional\_allowed\_fqdns) | List of additional allowed FQDNs | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | n/a |
| <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id) | n/a |
| <a name="output_databricks_workspace_url"></a> [databricks\_workspace\_url](#output\_databricks\_workspace\_url) | n/a |
<!-- END_TF_DOCS -->
