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

data "databricks_current_config" "this" {}

provider "databricks" {
  alias     = "sp"
  host      = data.databricks_current_config.this.host
  token     = databricks_obo_token.this.token_value
  auth_type = "pat"
}

resource "databricks_service_principal" "sp" {
  display_name = var.sp_name
}

resource "databricks_obo_token" "this" {
  application_id   = databricks_service_principal.sp.application_id
  comment          = "PAT on behalf of ${databricks_service_principal.sp.display_name}"
  lifetime_seconds = 3600
}


resource "databricks_git_credential" "sp" {
  provider              = databricks.sp
  depends_on            = [databricks_obo_token.this]
  git_username          = var.git_username
  git_provider          = var.git_service
  personal_access_token = var.git_token
}
