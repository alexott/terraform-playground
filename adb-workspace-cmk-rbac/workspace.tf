resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "dbfs" {
  depends_on = [azurerm_role_assignment.dbfs]

  workspace_id     = azurerm_databricks_workspace.this.id
  key_vault_key_id = azurerm_key_vault_key.dbfs.id
}

resource "azurerm_databricks_workspace" "this" {
  depends_on = [azurerm_role_assignment.managed]

  name                        = "${var.prefix}-DW"
  resource_group_name         = data.azurerm_resource_group.this.name
  location                    = data.azurerm_resource_group.this.location
  sku                         = "premium"
  managed_resource_group_name = "${var.prefix}-DW-managed"

  customer_managed_key_enabled          = true
  managed_services_cmk_key_vault_key_id = azurerm_key_vault_key.notebooks.id
  managed_disk_cmk_key_vault_key_id     = azurerm_key_vault_key.disks.id

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.example.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  tags = var.tags
}

output "azurerm_databricks_workspace_url" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}"
}

