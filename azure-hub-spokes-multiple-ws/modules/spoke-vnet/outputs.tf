output "db_route_table_id" {
  value       = azurerm_route_table.this.id
  description = "Resource ID of the created route table"
}

output "db_nsg_id" {
  value       = azurerm_network_security_group.this.id
  description = "Resource ID of the created NSG"
}

output "vnet_resource_id" {
  value       = azurerm_virtual_network.this.id
  description = "Resource ID of the created VNet"
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the created VNet"
}