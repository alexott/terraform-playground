resource "databricks_pipeline" "dlt" {
  catalog    = "main"
  schema     = "tmp"
  name       = "Demo: DLT pipeline"
  serverless = true
  library {
    notebook {
      path = databricks_notebook.dlt.id
    }
  }
}
