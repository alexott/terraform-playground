locals {
  ext_locations      = lookup(var.config, "external_locations", [])
  ext_locations_info = { for k in local.ext_locations : k.name => k }

  ext_locations_bindings_tmp = { for k, v in local.ext_locations_info : k => lookup(v, "workspaces", []) if length(lookup(v, "workspaces", [])) > 0 }
  # TODO: add the current workspace into this list, but we don't have data source for that
  ext_locations_bindings = flatten([for k, v in local.ext_locations_bindings_tmp : [
    for w in v : jsonencode({
      external_location = k
      workspace         = w.id
      read_only         = lookup(w, "read_only", false)
    })
  ]])

}

resource "databricks_external_location" "this" {
  for_each = local.ext_locations_info

  name            = each.value.name
  comment         = lookup(each.value, "comment", null)
  url             = lookup(each.value, "url", null)
  credential_name = lookup(each.value, "credential_name", null)
  owner           = lookup(each.value, "owner", null)
  force_destroy   = lookup(each.value, "force_destroy", false)
}

resource "databricks_grants" "external_locations" {
  for_each = { for k, v in local.ext_locations_info : k => v if lookup(v, "grants", null) != null }

  external_location = each.key

  dynamic "grant" {
    for_each = { for k in lookup(each.value, "grants", []) : k.principal => k.privileges }
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

resource "databricks_workspace_binding" "ext_locations" {
  for_each       = toset(local.ext_locations_bindings)
  securable_name = jsondecode(each.value).external_location
  workspace_id   = jsondecode(each.value).workspace
  binding_type   = jsondecode(each.value).read_only ? "BINDING_TYPE_READ_ONLY" : "BINDING_TYPE_READ_WRITE"
  securable_type = "external_location"
}