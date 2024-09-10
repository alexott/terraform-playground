terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "databricks" {
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.account_id
}

provider "azurerm" {
  features {}
}

