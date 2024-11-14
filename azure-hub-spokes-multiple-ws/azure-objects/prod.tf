resource "azurerm_resource_group" "prod" {
  name     = "${local.name_prefix}-prod"
  location = local.location

  tags = merge(local.tags, {
    Type        = "Spoke"
    Environment = "Production"
  })
}

module "prod_vnet" {
  source                  = "../modules/spoke-vnet"
  resource_group_name     = azurerm_resource_group.prod.name
  resource_group_location = azurerm_resource_group.prod.location
  vnet_name               = local.prod_vnet_name
  vnet_cidrs              = [local.prod_cidr]
  plsubnet_cidrs          = [cidrsubnet(local.prod_cidr, 6, 0)]
  hub_vnet_name           = local.hub_vnet_name
  hub_rg_name             = azurerm_resource_group.hub.name
  hub_vnet_id             = module.hub_vnet.vnet_resource_id
  tags                    = azurerm_resource_group.prod.tags
}

module "prod_ws1" {
  source                  = "../modules/workspace"
  workspace_name          = "${local.name_prefix}-prod-ws1"
  vnet_name               = module.prod_vnet.vnet_name
  resource_group_name     = azurerm_resource_group.prod.name
  resource_group_location = azurerm_resource_group.prod.location
  public_subnet_cidr      = cidrsubnet(local.prod_cidr, 7, 2)
  private_subnet_cidr     = cidrsubnet(local.prod_cidr, 7, 3)
  tags                    = azurerm_resource_group.prod.tags
  nsg_resource_id         = module.prod_vnet.db_nsg_id
  route_table_resource_id = module.prod_vnet.db_route_table_id
  vnet_resource_id        = module.prod_vnet.vnet_resource_id
}
