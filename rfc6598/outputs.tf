output "bastion_public_ip" {
  value = module.vnet_with_ws.bastion_public_ip
}

output "databricks_workspace_id" {
  value = module.vnet_with_ws.databricks_workspace_id
}

output "databricks_workspace_url" {
  value = module.vnet_with_ws.databricks_workspace_url
}