data "databricks_group" "admins" {
  display_name = "admins"
}

resource "databricks_user" "this" {
  for_each  = toset(var.admin_users)
  user_name = each.value
}

resource "databricks_group_member" "user-is-admin" {
  for_each  = toset(var.admin_users)
  group_id  = data.databricks_group.admins.id
  member_id = databricks_user.this[each.value].id
}

resource "databricks_service_principal" "this" {
  for_each       = toset(var.admin_sps)
  application_id = each.value
}

resource "databricks_group_member" "sp-is-admin" {
  for_each  = toset(var.admin_sps)
  group_id  = data.databricks_group.admins.id
  member_id = databricks_service_principal.this[each.value].id
}
