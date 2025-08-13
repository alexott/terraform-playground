output "firewall_vnet_id" {
  value = azurerm_virtual_network.firewall_vnet.id
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_public_ip.ip_address
}

output "firewall_subnet_address_prefixes" {
  value = azurerm_subnet.firewall_subnet.address_prefixes
}

output "dbfs_storage_account_name" {
  value = azurerm_databricks_workspace.this.custom_parameters[0].storage_account_name
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.this.id
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}