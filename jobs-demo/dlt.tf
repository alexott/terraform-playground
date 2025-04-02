resource "databricks_pipeline" "dlt" {
  catalog = "main"
  schema  = "tmp"
  name    = "Demo: DLT pipeline"
  library {
    notebook {
      path = databricks_notebook.dlt.id
    }
  }
}
