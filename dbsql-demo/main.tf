terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.21.0"
    }
  }
}

provider "databricks" {
}

