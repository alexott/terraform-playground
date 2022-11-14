resource "databricks_permissions" "many_tasks_example" {
  job_id = databricks_job.many_tasks_example.id

  access_control {
    group_name       = "users"
    permission_level = "CAN_VIEW"
  }
}