terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.76.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.28.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
}

