resource "databricks_directory" "demo_directory" {
  path = "${data.databricks_current_user.me.home}/Terraform-Jobs"
}

resource "databricks_notebook" "test1" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test1"
}

resource "databricks_notebook" "test2" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test2"
}

resource "databricks_notebook" "cleanup" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Cleanup_on_failure"
}

resource "databricks_notebook" "dlt" {
  source = "${path.module}/notebooks/DltTest.py"
  path   = "${databricks_directory.demo_directory.path}/DLTTest"
}