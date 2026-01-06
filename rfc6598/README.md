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
<!-- END_TF_DOCS -->
