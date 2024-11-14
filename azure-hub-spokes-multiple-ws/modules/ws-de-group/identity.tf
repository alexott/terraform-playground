resource "databricks_group" "this" {
  display_name          = var.group_name
  workspace_access      = true
  databricks_sql_access = true
}

resource "databricks_user" "this" {
  for_each  = toset(var.user_names)
  user_name = each.value
}

resource "databricks_group_member" "data_eng_member" {
  for_each  = toset(var.user_names)
  group_id  = databricks_group.this.id
  member_id = databricks_user.this[each.value].id
}
