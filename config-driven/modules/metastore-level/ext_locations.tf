locals {
  ext_locations      = lookup(var.config, "external_locations", [])
  ext_locations_info = { for k in local.ext_locations : k.name => k }
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