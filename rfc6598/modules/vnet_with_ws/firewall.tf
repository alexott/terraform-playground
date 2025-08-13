resource "azurerm_firewall" "firewall" {
  name                = "${var.name_prefix}-firewall"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  private_ip_ranges = ["255.255.255.255/32"]

  management_ip_configuration {
    name                 = "${var.name_prefix}-firewall-management-ip-configuration"
    subnet_id            = azurerm_subnet.firewall_management_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  ip_configuration {
    name      = "${var.name_prefix}-firewall-ip-configuration"
    subnet_id = azurerm_subnet.firewall_subnet.id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "${var.name_prefix}-firewall-public-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_network_rule_collection" "allow_all" {
  name                = "allow-all"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "all"

    source_addresses = [
      "0.0.0.0/0",
    ]

    destination_ports = [
      "1-65535",
    ]

    destination_addresses = [
      "0.0.0.0/0",
    ]

    protocols = [
      "Any",
    ]
  }

}