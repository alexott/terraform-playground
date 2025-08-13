module "vnet_with_ws" {
  source      = "./modules/vnet_with_ws"
  rg_name     = var.rg_name
  rg_location = var.rg_location
  name_prefix = var.name_prefix
  tags        = var.tags

  firewall_vnet_cidr              = "10.0.1.0/25"
  firewall_subnet_cidr            = "10.0.1.0/26"
  firewall_management_subnet_cidr = "10.0.1.64/26"

  hub_vnet_id     = azurerm_virtual_network.hub_vnet.id
  hub_firewall_ip = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address

}
