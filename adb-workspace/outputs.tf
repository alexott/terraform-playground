output "databricks_azure_workspace_resource_id" {
  value = azurerm_databricks_workspace.example.id
}

output "workspace_url" {
  value = "https://${azurerm_databricks_workspace.example.workspace_url}/"
}
