resource "azurerm_resource_group" "dev" {
  name     = "${local.name_prefix}-dev"
  location = local.location

  tags = merge(local.tags, {
    Type        = "Spoke"
    Environment = "Dev"
  })
}

module "dev_vnet" {
  source                  = "../modules/spoke-vnet"
  resource_group_name     = azurerm_resource_group.dev.name
  resource_group_location = azurerm_resource_group.dev.location
  vnet_name               = local.dev_vnet_name
  vnet_cidrs              = [local.dev_cidr]
  plsubnet_cidrs          = [cidrsubnet(local.dev_cidr, 6, 0)]
  hub_vnet_name           = local.hub_vnet_name
  hub_rg_name             = azurerm_resource_group.hub.name
  hub_vnet_id             = module.hub_vnet.vnet_resource_id
  tags                    = azurerm_resource_group.dev.tags
}

module "dev_ws1" {
  source                  = "../modules/workspace"
  workspace_name          = "${local.name_prefix}-dev-ws1"
  vnet_name               = module.dev_vnet.vnet_name
  resource_group_name     = azurerm_resource_group.dev.name
  resource_group_location = azurerm_resource_group.dev.location
  public_subnet_cidr      = cidrsubnet(local.dev_cidr, 7, 2)
  private_subnet_cidr     = cidrsubnet(local.dev_cidr, 7, 3)
  tags                    = azurerm_resource_group.dev.tags
  nsg_resource_id         = module.dev_vnet.db_nsg_id
  route_table_resource_id = module.dev_vnet.db_route_table_id
  vnet_resource_id        = module.dev_vnet.vnet_resource_id
} 