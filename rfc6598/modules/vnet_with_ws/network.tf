# VNet and subnets for the Databricks workspace and auxiliary resources
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-ws-vnet"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "${var.name_prefix}-pe-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.pe_subnet_cidr]
}

resource "azurerm_subnet" "utility_subnet" {
  name                 = "${var.name_prefix}-utility-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.utility_subnet_cidr]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

locals {
  service_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
}

resource "azurerm_subnet" "host_subnet" {
  name                 = "${var.name_prefix}-host-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.host_subnet_cidr]

  delegation {
    name = "${var.name_prefix}-host-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }
}

resource "azurerm_subnet" "container_subnet" {
  name                 = "${var.name_prefix}-container-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.container_subnet_cidr]

  delegation {
    name = "${var.name_prefix}-container-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }
}

resource "azurerm_virtual_network" "firewall_vnet" {
  name                = "${var.name_prefix}-firewall-vnet"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.firewall_vnet_cidr]
  tags                = var.tags
}

# VNet and subnets for the firewall
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.firewall_vnet.name
  address_prefixes     = [var.firewall_subnet_cidr]
}

resource "azurerm_subnet" "firewall_management_subnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.firewall_vnet.name
  address_prefixes     = [var.firewall_management_subnet_cidr]
}

# Peering between the vnet and the firewall vnet
resource "azurerm_virtual_network_peering" "vnet_to_firewall_vnet" {
  name                      = "${var.name_prefix}-vnet-to-firewall-vnet"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.firewall_vnet.id
}

resource "azurerm_virtual_network_peering" "firewall_vnet_to_vnet" {
  name                      = "${var.name_prefix}-firewall-vnet-to-vnet"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.firewall_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "hub_vnet_to_firewall_vnet" {
  name                      = "${var.name_prefix}-hub-vnet-to-firewall-vnet"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.firewall_vnet.name
  remote_virtual_network_id = var.hub_vnet_id
}

# Routes for the firewall
resource "azurerm_route_table" "firewall_route_table" {
  name                = "${var.name_prefix}-firewall-route-table"
  location            = var.rg_location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_route" "firewall_route" {
  name                   = "${var.name_prefix}-firewall-route"
  resource_group_name    = var.rg_name
  route_table_name       = azurerm_route_table.firewall_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "host_subnet_association" {
  subnet_id      = azurerm_subnet.host_subnet.id
  route_table_id = azurerm_route_table.firewall_route_table.id
}

resource "azurerm_subnet_route_table_association" "container_subnet_association" {
  subnet_id      = azurerm_subnet.container_subnet.id
  route_table_id = azurerm_route_table.firewall_route_table.id
}

# Hub firewall route table
resource "azurerm_route_table" "hub_firewall_route_table" {
  name                = "${var.name_prefix}-hub-firewall-route-table"
  location            = var.rg_location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_route" "hub_firewall_route" {
  name                   = "${var.name_prefix}-hub-firewall-route"
  resource_group_name    = var.rg_name
  route_table_name       = azurerm_route_table.hub_firewall_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.hub_firewall_ip
}

resource "azurerm_subnet_route_table_association" "hub_firewall_route_table_association" {
  subnet_id      = azurerm_subnet.firewall_subnet.id
  route_table_id = azurerm_route_table.hub_firewall_route_table.id
}

