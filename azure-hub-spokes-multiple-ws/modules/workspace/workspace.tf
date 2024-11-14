resource "azurerm_databricks_workspace" "this" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "premium"
  tags                = var.tags
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_resource_id
    private_subnet_name                                  = azurerm_subnet.private.name
    public_subnet_name                                   = azurerm_subnet.public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }
  # We need this, otherwise destroy doesn't cleanup things correctly
  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private
  ]
}
