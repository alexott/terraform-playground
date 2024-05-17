resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet-databricks"
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-sn-public"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.public_subnet_address_prefixes

  delegation {
    name = "databricks-del-pub-${var.prefix}"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-sn-private"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.private_subnet_address_prefixes

  delegation {
    name = "databricks-del-pri-${var.prefix}"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-nsg-databricks"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  tags = var.tags
}

