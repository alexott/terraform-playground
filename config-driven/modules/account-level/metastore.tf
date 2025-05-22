locals {
  metastore_name   = lookup(var.config.metastore, "name", var.config.metastore.location)
  create_metastore = lookup(var.config.metastore, "create", false)
  metastore_id     = local.create_metastore ? databricks_metastore.this[0].id : data.databricks_metastore.this[0].id
  workspace_ids    = [for k in flatten(lookup(var.config.metastore, "workspaces", [])) : tostring(k)]
}

resource "databricks_metastore" "this" {
  count  = local.create_metastore ? 1 : 0
  name   = local.metastore_name
  region = var.config.metastore.location
  owner  = lookup(var.config.metastore, "owner", null)
}

data "databricks_metastore" "this" {
  count = local.create_metastore ? 0 : 1
  name  = local.metastore_name
}

resource "databricks_metastore_assignment" "this" {
  for_each     = toset(local.workspace_ids)
  metastore_id = local.metastore_id
  workspace_id = tonumber(each.value)
}

