resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_cidrs
  tags                = var.tags
}

