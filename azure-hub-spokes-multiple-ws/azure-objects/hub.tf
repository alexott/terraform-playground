resource "azurerm_resource_group" "hub" {
  name     = "${local.name_prefix}-hub"
  location = local.location
  tags = merge(local.tags, {
    Type = "Hub"
    Environment = "Production"
  })
}

module "hub_vnet" {
  depends_on              = [azurerm_resource_group.hub]
  source                  = "../modules/hub-vnet"
  resource_group_name     = azurerm_resource_group.hub.name
  resource_group_location = azurerm_resource_group.hub.location
  vnet_name               = local.hub_vnet_name
  vnet_cidrs              = [local.hub_cidr]
  tags                    = azurerm_resource_group.hub.tags
}