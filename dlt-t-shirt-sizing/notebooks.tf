resource "databricks_directory" "dlt" {
  path = "${data.databricks_current_user.me.home}/TestDLT"
}

resource "databricks_notebook" "dlt_python" {
  source = "${path.module}/notebooks/DLT.py"
  path   = "${databricks_directory.dlt.path}/Python"
}
