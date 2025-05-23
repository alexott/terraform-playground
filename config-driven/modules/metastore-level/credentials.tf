locals {
  service_credentials      = lookup(var.config, "credentials", [])
  service_credentials_info = { for k in local.service_credentials : k.name => k }

  service_credentials_bindings_tmp = { for k, v in local.service_credentials_info : k => lookup(v, "workspaces", []) if length(lookup(v, "workspaces", [])) > 0 }
  # TODO: add the current workspace into this list, but we don't have data source for that
  service_credentials_bindings = flatten([for k, v in local.service_credentials_bindings_tmp : [
    for w in v : jsonencode({
      service_credential = k
      workspace          = w.id
      read_only          = lookup(w, "read_only", false)
    })
  ]])

}

resource "databricks_credential" "this" {
  for_each = local.service_credentials_info

  name    = each.value.name
  owner   = lookup(each.value, "owner", null)
  comment = lookup(each.value, "comment", null)
  purpose = lookup(each.value, "purpose", "SERVICE")

  dynamic "azure_managed_identity" {
    for_each = lookup(each.value, "azure_managed_identity", null) == null ? {} : {
      value = lookup(each.value, "azure_managed_identity", null)
    }
    content {
      access_connector_id = azure_managed_identity.value.access_connector_id
      managed_identity_id = lookup(azure_managed_identity.value, "managed_identity_id", null)
    }
  }

  dynamic "aws_iam_role" {
    for_each = lookup(each.value, "aws_iam_role", null) == null ? {} : {
      value = lookup(each.value, "aws_iam_role", null)
    }
    content {
      role_arn = aws_iam_role.value.role_arn
    }
  }
}

resource "databricks_grants" "service_credentials" {
  for_each = { for k, v in local.service_credentials_info : k => v if lookup(v, "grants", null) != null }

  credential = each.key

  dynamic "grant" {
    for_each = { for k in lookup(each.value, "grants", []) : k.principal => k.privileges }
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

resource "databricks_workspace_binding" "service_credentials" {
  for_each       = toset(local.service_credentials_bindings)
  securable_name = jsondecode(each.value).storage_credential
  workspace_id   = jsondecode(each.value).workspace
  binding_type   = jsondecode(each.value).read_only ? "BINDING_TYPE_READ_ONLY" : "BINDING_TYPE_READ_WRITE"
  securable_type = "credential"
}