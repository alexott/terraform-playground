resource "databricks_job" "dlt_pipeline" {
  name = "Job for ${var.pipeline_name}"
  task {
    task_key = "DLT"
    pipeline_task {
      pipeline_id = databricks_pipeline.dlt_pipeline.id
    }
  }
  schedule {
    quartz_cron_expression = "0 0 1 * * ?"
    timezone_id            = "UTC"
    pause_status           = var.active_region ? "UNPAUSED" : "PAUSED"
  }
}

