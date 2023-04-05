resource "databricks_pipeline" "dlt_pipeline" {
  channel     = "CURRENT"
  continuous  = var.active_region
  development = false
  edition     = var.pipeline_edition
  name        = var.pipeline_name
  photon      = false
  storage     = var.pipeline_storage
  target      = var.pipeline_target

  dynamic "library" {
    for_each = toset(var.notebooks)
    content {
      notebook {
        path = databricks_notebook.dlt_pipeline[library.value].id
      }
    }
  }

  # TODO: add clusters customizations (init scripts, ...)
  # TODO: add custom tags

}
