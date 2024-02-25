# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.34.0"
    }
  }
}

provider "databricks" {
  host = azurerm_databricks_workspace.example.workspace_url
}

data "databricks_current_user" "me" {
  depends_on = [azurerm_databricks_workspace.example]
}

output "user" {
  value = data.databricks_current_user.me
}

provider "azurerm" {
  features {}
}

provider "random" {
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

resource "azurerm_resource_group" "this" {
  name     = "${random_string.naming.result}-basic-demo-rg"
  location = var.rglocation
  tags     = local.tags
}

locals {
  prefix   = join("-", [var.workspace_prefix, "${random_string.naming.result}"])
  location = var.rglocation
  dbfsname = join("", [var.dbfs_prefix, "${random_string.naming.result}"]) // dbfs name must not have special chars

  // tags that are propagated down to all resources
  tags = merge({
    Environment = "Testing"
    Epoch       = random_string.naming.result
  }, var.tags)
}
