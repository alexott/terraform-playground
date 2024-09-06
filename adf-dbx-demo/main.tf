terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}

locals {
  workspace_url = "https://${data.azurerm_databricks_workspace.this.workspace_url}"
}

provider "databricks" {
  host = local.workspace_url
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  # Configuration options
}



data "azurerm_resource_group" "this" {
  name = var.rg_name
}

