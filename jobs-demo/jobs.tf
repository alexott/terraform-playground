resource "databricks_job" "many_tasks_example" {
  task {
    task_key = "Task1"
    notebook_task {
      notebook_path = databricks_notebook.test1.id
    }
    job_cluster_key = "Shared_job_cluster"
  }
  task {
    task_key = "Task2"
    notebook_task {
      notebook_path = databricks_notebook.test2.id
    }
    job_cluster_key = "Shared_job_cluster"
    depends_on {
      task_key = "Task1"
    }
  }
  task {
    task_key = "Task3"
    notebook_task {
      notebook_path = databricks_notebook.test3.id
    }
    job_cluster_key = "Shared_job_cluster"
    depends_on {
      task_key = "Task1"
    }
  }
  task {
    task_key = "Task4"
    notebook_task {
      notebook_path = databricks_notebook.test4.id
    }
    job_cluster_key = "Shared_job_cluster"
    depends_on {
      task_key = "Task3"
    }
    depends_on {
      task_key = "Task2"
    }
  }
  task {
    task_key = "Task5"
    notebook_task {
      notebook_path = databricks_notebook.test5.id
    }
    job_cluster_key = "Shared_job_cluster"
    depends_on {
      task_key = "Task3"
    }
  }
  task {
    task_key = "Task6"
    notebook_task {
      notebook_path = databricks_notebook.test6.id
    }
    job_cluster_key = "Shared_job_cluster"
    depends_on {
      task_key = "Task4"
    }
    depends_on {
      task_key = "Task5"
    }
  }
  name = "Job with multiple tasks example"
  job_cluster {
    new_cluster {
      spark_version = data.databricks_spark_version.latest_lts.id
      num_workers         = 2
      node_type_id        = data.databricks_node_type.smallest.id
    }
    job_cluster_key = "Shared_job_cluster"
  }
}

output "job_url" {
  value = databricks_job.many_tasks_example.url
}