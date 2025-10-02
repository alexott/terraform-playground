terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  dbfs_storage_account_name = replace(lower(var.dbfs_storage_account_name != "" ? var.dbfs_storage_account_name : "${local.databricks_workspace_name}-dbfs"), "/[^a-z0-9]+/", "")
  dbfs_storage_account_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${local.managed_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.dbfs_storage_account_name}"
  databricks_workspace_name = var.databricks_workspace_name != "" ? var.databricks_workspace_name : "${var.prefix}-ws"
}

output "workspace_url" {
  value       = "https://${azurerm_databricks_workspace.this.workspace_url}"
  description = "URL of the Databricks workspace"
}

output "workspace_id" {
  value       = azurerm_databricks_workspace.this.workspace_id
  description = "ID of the Databricks workspace"
}

