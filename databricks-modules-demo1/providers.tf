terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# This will be uncommented as part of the demo

# provider "databricks" {
#   alias      = "account"
#   host       = "https://accounts.azuredatabricks.net"
#   account_id = var.account_id
# }

# provider "databricks" {
#   alias = "workspace"
#   host  = module.adb-lakehouse.workspace_url
# }
