resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_cidrs
  tags                = var.tags
}

resource "azurerm_subnet" "plsubnet" {
  name                 = var.plsubnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.plsubnet_cidrs
}

resource "azurerm_virtual_network_peering" "hubvnet" {
  name                      = "peerhubtospoke-${var.vnet_name}"
  resource_group_name       = var.hub_rg_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
}

resource "azurerm_virtual_network_peering" "spokevnet" {
  name                      = "peerspoketohub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-databricks-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_route_table" "this" {
  name                = "databricks-route"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "localvnet" {
  for_each            = toset(var.vnet_cidrs)
  name                = replace("local-${each.value}", "/", "-")
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = each.value
  next_hop_type       = "VnetLocal"
}

resource "azurerm_route" "default" {
  name                = "default"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet" // Forward to Hub instead
}
