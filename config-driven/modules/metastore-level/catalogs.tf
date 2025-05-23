locals {
  catalogs      = lookup(var.config, "catalogs", [])
  catalogs_info = { for k in local.catalogs : k.name => k }

  catalogs_bindings_tmp = { for k, v in local.catalogs_info : k => lookup(v, "workspaces", []) if length(lookup(v, "workspaces", [])) > 0 }
  # TODO: add the current workspace into this list, but we don't have data source for that
  catalogs_bindings = flatten([for k, v in local.catalogs_bindings_tmp : [
    for w in v : jsonencode({
      catalog   = k
      workspace = w.id
      read_only = lookup(w, "read_only", false)
    })
  ]])
}

# TODO: add support for shares and connections
resource "databricks_catalog" "this" {
  for_each = local.catalogs_info

  name           = each.value.name
  comment        = lookup(each.value, "comment", null)
  owner          = lookup(each.value, "owner", null)
  storage_root   = lookup(each.value, "storage_root", null)
  force_destroy  = lookup(each.value, "force_destroy", false)
  properties     = lookup(each.value, "properties", null)
  options        = lookup(each.value, "options", null)
  isolation_mode = length(lookup(each.value, "workspaces", [])) > 0 ? "ISOLATED" : "OPEN"
}

resource "databricks_workspace_binding" "catalogs" {
  for_each       = toset(local.catalogs_bindings)
  securable_name = jsondecode(each.value).catalog
  workspace_id   = jsondecode(each.value).workspace
  binding_type   = jsondecode(each.value).read_only ? "BINDING_TYPE_READ_ONLY" : "BINDING_TYPE_READ_WRITE"
  securable_type = "catalog"
}

resource "databricks_grants" "catalogs" {
  for_each = { for k, v in local.catalogs_info : k => v if lookup(v, "grants", null) != null }

  catalog = each.key

  dynamic "grant" {
    for_each = { for k in lookup(each.value, "grants", []) : k.principal => k.privileges }
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}