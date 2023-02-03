resource "databricks_directory" "dlt" {
  path = "${data.databricks_current_user.me.home}/TestDLT"
}

resource "databricks_notebook" "dlt_python" {
  source = "${path.module}/notebooks/DLT.py"
  path   = "${databricks_directory.dlt.path}/Python"
}

resource "databricks_notebook" "dlt_sql" {
  source = "${path.module}/notebooks/DLT.sql"
  path   = "${databricks_directory.dlt.path}/SQL"
}
