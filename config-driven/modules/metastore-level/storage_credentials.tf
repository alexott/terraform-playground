locals {
  storage_credentials = lookup(var.config, "storage_credentials", [])

  storage_credentials_info = { for k in local.storage_credentials : k.name => k }
}

resource "databricks_storage_credential" "this" {
  for_each = local.storage_credentials_info

  name    = each.value.name
  owner   = lookup(each.value, "owner", null)
  comment = lookup(each.value, "comment", null)

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

resource "databricks_grants" "storage_credentials" {
  for_each = { for k, v in local.storage_credentials_info : k => v if lookup(v, "grants", null) != null }

  storage_credential = each.key

  dynamic "grant" {
    for_each = { for k in lookup(each.value, "grants", []) : k.principal => k.privileges }
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}