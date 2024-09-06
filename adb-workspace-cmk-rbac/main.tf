terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.44.0"
    }
  }
}

data "azurerm_client_config" "current" {}

provider "azuread" {
}

provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "this" {
  name = var.rg_name
}

provider "databricks" {
  host = "https://${azurerm_databricks_workspace.this.workspace_url}"
}

