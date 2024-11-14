resource "databricks_pipeline" "this" {
  name    = "Project 1 Pipeline"
  storage = "/test/first-pipeline"
  configuration = {
    Project = "Project1"
  }

  cluster {
    label       = "default"
    num_workers = 2
    custom_tags = {
      cluster_type = "default"
    }
  }

  cluster {
    label       = "maintenance"
    num_workers = 1
    custom_tags = {
      cluster_type = "maintenance"
    }
  }

  library {
    notebook {
      path = databricks_notebook.dlt_demo.id
    }
  }
  
  continuous = false
  development = false

  notification {
    email_recipients = ["user@domain.com", "user1@domain.com"]
    alerts = [
      "on-update-failure",
      "on-update-fatal-failure",
      "on-update-success",
      "on-flow-failure"
    ]
  }
}