resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.name_prefix}-hub-vnet"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.hub_vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "hub_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.hub_firewall_subnet_cidr]
}

resource "azurerm_virtual_network_peering" "firewall_vnet_to_hub_vnet" {
  name                      = "${var.name_prefix}-firewall-vnet-to-hub-vnet"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = module.vnet_with_ws.firewall_vnet_id
}

