locals {
  service_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]

  managed_resource_group_name = var.managed_resource_group_name == "" ? "${local.databricks_workspace_name}-managed-rg" : var.managed_resource_group_name
}

resource "azurerm_subnet" "container" {
  name                 = "${local.databricks_workspace_name}-container-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_subnet_address_prefixes

  delegation {
    name = "databricks-private-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }
}

resource "azurerm_subnet" "host" {
  name                 = "${local.databricks_workspace_name}-host-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes  = var.public_subnet_address_prefixes
  service_endpoints = var.service_endpoints
  service_endpoint_policy_ids = [
    azurerm_subnet_service_endpoint_storage_policy.dbfs.id,
    azurerm_subnet_service_endpoint_storage_policy.uc.id
  ]

  delegation {
    name = "databricks-host-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "container" {
  subnet_id                 = azurerm_subnet.container.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "host" {
  subnet_id                 = azurerm_subnet.host.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_nat_gateway_association" "host" {
  subnet_id      = azurerm_subnet.host.id
  nat_gateway_id = azurerm_nat_gateway.this.id
}

resource "azurerm_databricks_workspace" "this" {
  name                        = local.databricks_workspace_name
  resource_group_name         = var.rg_name
  managed_resource_group_name = local.managed_resource_group_name
  location                    = var.rg_location
  sku                         = "premium"

  custom_parameters {
    virtual_network_id                                   = azurerm_virtual_network.this.id
    private_subnet_name                                  = azurerm_subnet.container.name
    public_subnet_name                                   = azurerm_subnet.host.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.container.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.host.id

    storage_account_name = local.dbfs_storage_account_name
  }

  tags = var.tags
}
