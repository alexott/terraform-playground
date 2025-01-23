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

resource "databricks_secret_scope" "default_pip_config" {
  name = "databricks-package-management"
}

resource "databricks_secret" "pip_index_url" {
  key          = "pip-index-url"
  string_value = var.pip_index_url
  scope        = databricks_secret_scope.default_pip_config.id
}

resource "databricks_secret" "pip_extra_index_url" {
  count = var.pip_extra_index_urls != "" ? 1 : 0
  key          = "pip-extra-index-urls"
  string_value = var.pip_extra_index_urls
  scope        = databricks_secret_scope.default_pip_config.id
}

resource "databricks_secret" "pip_ssl_cert" {
  count = var.pip_ssl_cert != "" ? 1 : 0
  key          = "pip-cert"
  string_value = var.pip_ssl_cert
  scope        = databricks_secret_scope.default_pip_config.id
}

resource "databricks_secret_acl" "users_acl" {
  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.default_pip_config.name
}

resource "databricks_secret_acl" "admins_acl" {
  principal  = "admins"
  permission = "MANAGE"
  scope      = databricks_secret_scope.default_pip_config.name
}
