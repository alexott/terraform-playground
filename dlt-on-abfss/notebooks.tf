resource "databricks_notebook" "dlt_test_abfss_python" {
  source = "${path.module}/notebooks/Test ABFSS - Python.py"
  path   = "${data.databricks_current_user.me.home}/Test ABFSS - Python"
}
resource "databricks_notebook" "dlt_test_abfss_sql" {
  source = "${path.module}/notebooks/Test ABFSS - SQL.sql"
  path   = "${data.databricks_current_user.me.home}/Test ABFSS - SQL"
}
