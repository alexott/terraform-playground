terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.4.0"
    }
  }
}

provider "databricks" {
}

