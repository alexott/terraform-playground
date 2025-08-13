# Network security groups
resource "azurerm_network_security_group" "this" {
  name                = "${var.name_prefix}-ws-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "host_subnet_association" {
  subnet_id                 = azurerm_subnet.host_subnet.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "container_subnet_association" {
  subnet_id                 = azurerm_subnet.container_subnet.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${var.name_prefix}-ws"
  resource_group_name         = var.rg_name
  managed_resource_group_name = "${var.name_prefix}-ws-rg"
  location                    = var.rg_location
  sku                         = "premium"
  tags                        = var.tags

  custom_parameters {
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    private_subnet_name                                  = azurerm_subnet.host_subnet.name
    public_subnet_name                                   = azurerm_subnet.container_subnet.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.host_subnet_association.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.container_subnet_association.id
  }
}
