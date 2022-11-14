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

resource "databricks_notebook" "test3" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test4"
}

resource "databricks_notebook" "test4" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test4"
}

resource "databricks_notebook" "test5" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test5"
}

resource "databricks_notebook" "test6" {
  source = "${path.module}/notebooks/Test.py"
  path   = "${databricks_directory.demo_directory.path}/Test6"
}

