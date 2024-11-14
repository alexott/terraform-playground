locals {
  sql_warehouse_tags = merge(var.tags, {
    Team = var.group_name
  })
}

resource "databricks_sql_endpoint" "this" {
  name                      = var.group_name
  cluster_size              = var.warehouse_size
  auto_stop_mins            = var.auto_stop_mins
  enable_serverless_compute = var.serverless_enabled
  warehouse_type            = var.warehouse_sku

  dynamic "tags" {
    for_each = local.sql_warehouse_tags
    content {
      custom_tags {
        key   = tags.key
        value = tags.value
      }
    }
  }
}

resource "databricks_permissions" "endpoint_usage" {
  sql_endpoint_id = databricks_sql_endpoint.this.id

  access_control {
    group_name       = databricks_group.this.display_name
    permission_level = "CAN_USE"
  }
}
