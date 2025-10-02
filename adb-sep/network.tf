resource "azurerm_virtual_network" "this" {
  name                = "${local.databricks_workspace_name}-VNET"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.spoke_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  name                = "${local.databricks_workspace_name}-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  name                = "${local.databricks_workspace_name}-nat-gateway"
  location            = var.rg_location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_public_ip" "this" {
  name                = "${local.databricks_workspace_name}-nat-gateway-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this.id
}
