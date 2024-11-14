resource "azurerm_subnet" "public" {
  name                 = "${var.workspace_name}-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.public_subnet_cidr]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = var.nsg_resource_id
}

resource "azurerm_subnet_route_table_association" "publicudr" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = var.route_table_resource_id
}

resource "azurerm_subnet" "private" {
  name                 = "${var.workspace_name}-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.private_subnet_cidr]

  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }

  //  service_endpoints = var.private_subnet_endpoints
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = var.nsg_resource_id
}

resource "azurerm_subnet_route_table_association" "privateudr" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = var.route_table_resource_id
}
