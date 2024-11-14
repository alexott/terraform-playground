locals {
  tags = merge(var.tags, {
    Team = var.group_name
  })
}

resource "databricks_sql_endpoint" "this" {
  name             = "Endpoint of ${var.group_name}"
  cluster_size     = "X-Small"
  max_num_clusters = 3
  min_num_clusters = 1
  auto_stop_mins   = 5

  enable_serverless_compute = true
  warehouse_type            = "PRO"

  dynamic "tags" {
    for_each = local.tags
    content {
      custom_tags {
        key   = tags.key
        value = tags.value
      }
    }
  }
}

resource "databricks_permissions" "can_manage_sql_endpoint" {
  sql_endpoint_id = databricks_sql_endpoint.this.id

  access_control {
    group_name       = databricks_group.this.display_name
    permission_level = "CAN_MANAGE"
  }
}
