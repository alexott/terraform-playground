// read group members of given groups from AzureAD every time Terraform is started
data "azuread_group" "this" {
  for_each     = local.all_groups
  display_name = each.value
}

locals {
  all_groups   = toset(keys(var.groups))
  admin_groups = toset([for k, v in var.groups : k if v.admin])
}

// create or remove groups within databricks - all governed by "groups" variable
resource "databricks_group" "this" {
  for_each                   = data.azuread_group.this
  display_name               = each.key
  external_id                = data.azuread_group.this[each.key].object_id
  workspace_access           = var.groups[each.key].workspace_access
  databricks_sql_access      = var.groups[each.key].databricks_sql_access
  allow_cluster_create       = var.groups[each.key].allow_cluster_create
  allow_instance_pool_create = var.groups[each.key].allow_instance_pool_create
  force                      = true
}

locals {
  all_members = toset(flatten([for group in values(data.azuread_group.this) : group.members]))
}

// Extract information about real users
data "azuread_users" "users" {
  ignore_missing = true
  object_ids     = local.all_members
}

locals {
  all_users = {
    for user in data.azuread_users.users.users : user.object_id => user
  }
}

// all governed by AzureAD, create or remove users from databricks workspace
resource "databricks_user" "this" {
  for_each     = local.all_users
  user_name    = lower(local.all_users[each.key]["user_principal_name"])
  display_name = local.all_users[each.key]["display_name"]
  active       = local.all_users[each.key]["account_enabled"]
  external_id  = each.key
  force        = true
}

// Provision Service Principals
data "azuread_service_principals" "spns" {
  object_ids = toset(setsubtract(local.all_members, data.azuread_users.users.object_ids))
}

locals {
  all_spns = {
    for sp in data.azuread_service_principals.spns.service_principals : sp.object_id => sp
  }
}

resource "databricks_service_principal" "sp" {
  for_each       = local.all_spns
  application_id = local.all_spns[each.key]["application_id"]
  display_name   = local.all_spns[each.key]["display_name"]
  active         = local.all_spns[each.key]["account_enabled"]
  external_id    = each.key
  force          = true
}

locals {
  merged_data = merge(databricks_user.this, databricks_service_principal.sp)
}

// put users to respective groups
resource "databricks_group_member" "this" {
  for_each = toset(flatten([
    for group, details in data.azuread_group.this : [
      for member in details["members"] : jsonencode({
        group  = databricks_group.this[group].id,
        member = local.merged_data[member].id
      })
    ]
  ]))
  group_id  = jsondecode(each.value).group
  member_id = jsondecode(each.value).member
}

// Provisioning Admins
data "azuread_group" "admins" {
  for_each     = local.admin_groups
  display_name = each.value
}

data "databricks_group" "admins" {
  display_name = "admins"
}

resource "databricks_group_member" "admins" {
  for_each = toset(flatten([
    for group, details in data.azuread_group.admins : [
      for member in details["members"] : local.merged_data[member].id
    ]
  ]))
  group_id  = data.databricks_group.admins.id
  member_id = each.value
}
