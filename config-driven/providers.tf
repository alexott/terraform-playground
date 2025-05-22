terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.80.0"
    }
  }
}

provider "databricks" {
  account_id = var.databricks_account_id
  host       = "https://accounts.azuredatabricks.net"
  alias      = "account"
}

provider "databricks" {
  host  = local.uc_admin_workspace
  alias = "workspace"
}

