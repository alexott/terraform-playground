terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
  # Configuration options
}

data "databricks_current_user" "me" {}
