resource "databricks_job" "many_tasks_example" {
  task {
    task_key = "Task_Job_Cluster"
    notebook_task {
      notebook_path = databricks_notebook.test1.id
    }
    job_cluster_key = "Shared_job_cluster"
  }
  task {
    task_key = "Task_Serverless"
    notebook_task {
      notebook_path = databricks_notebook.test2.id
    }
  }
  task {
    task_key = "DLT"
    pipeline_task {
      pipeline_id = databricks_pipeline.dlt.id
    }
    depends_on {
      task_key = "Task_Job_Cluster"
    }
    depends_on {
      task_key = "Task_Serverless"
    }
  }
  task {
    task_key = "Cleanup_on_failure"
    run_if   = "AT_LEAST_ONE_FAILED"
    notebook_task {
      notebook_path = databricks_notebook.cleanup.id
    }
    depends_on {
      task_key = "DLT"
    }
  }
  task {
    task_key = "Trigger_alert"
    sql_task {
      warehouse_id = databricks_sql_endpoint.this.id
      alert {
        subscriptions {
          user_name = "alexey.ott@databricks.com"
        }
        pause_subscriptions = true
        alert_id            = databricks_alert.this.id
      }
    }
    run_if = "ALL_SUCCESS"
    depends_on {
      task_key = "DLT"
    }
  }

  name = "Demo: Job with multiple tasks"
  job_cluster {
    new_cluster {
      spark_version = data.databricks_spark_version.latest_lts.id
      num_workers   = 2
      node_type_id  = data.databricks_node_type.smallest.id
    }
    job_cluster_key = "Shared_job_cluster"
  }

  trigger {
    periodic {
      unit     = "DAYS"
      interval = 1
    }
    pause_status = "PAUSED"
  }

}

output "job_url" {
  value = databricks_job.many_tasks_example.url
}