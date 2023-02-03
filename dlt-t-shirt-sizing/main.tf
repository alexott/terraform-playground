terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  # Configuration options
}

data "databricks_current_user" "me" {}
