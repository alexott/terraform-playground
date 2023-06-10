terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.1.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "databricks" {
}
