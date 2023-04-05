resource "databricks_notebook" "dlt_pipeline" {
  for_each = toset(var.notebooks)
  source = "${path.module}/notebooks/${each.value}"
  path   = "${var.notebooks_directory}/${each.value}"
}