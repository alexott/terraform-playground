resource "databricks_sql_endpoint" "this" {
  warehouse_type            = "PRO"
  name                      = "Demo: SQL Endpoint"
  min_num_clusters          = 1
  enable_serverless_compute = true
  cluster_size              = "2X-Small"
  auto_stop_mins = 5  
}

resource "databricks_query" "this" {
  warehouse_id     = databricks_sql_endpoint.this.id
  run_as_mode      = "OWNER"
  query_text       = "select 42 as threshold"
  parent_path      = databricks_directory.demo_directory.id
  display_name     = "Demo: Alert Query"
  apply_auto_limit = true
}

resource "databricks_alert" "this" {
  query_id        = databricks_query.this.id
  parent_path     = databricks_directory.demo_directory.id
  display_name    = "Demo: Test Alert"
  condition {
    threshold {
      value {
        string_value = "50"
      }
    }
    operand {
      column {
        name = "threshold"
      }
    }
    op = "GREATER_THAN"
  }
}
