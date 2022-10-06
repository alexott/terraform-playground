resource "databricks_sql_endpoint" "demo" {
  name           = "Demo endpoint"
  cluster_size   = "Small"
  auto_stop_mins = 10
}
