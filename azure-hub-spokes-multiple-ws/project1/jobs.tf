resource "databricks_job" "this" {
  name = "Project 1 production pipeline"

 task {
    task_key = "dlt_pipeline"

    pipeline_task {
      pipeline_id = databricks_pipeline.this.id
    }
  }
}