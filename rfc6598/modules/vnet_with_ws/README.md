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
<!-- END_TF_DOCS -->
