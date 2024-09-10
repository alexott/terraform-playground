terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
}

data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}
data "databricks_node_type" "smallest" {
  local_disk = true
}
