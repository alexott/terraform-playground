resource "databricks_job" "this" {
  name = "Terraform SQL Job"

  task {
    task_key = "query"
    sql_task {
      warehouse_id = databricks_sql_endpoint.demo.id
      query {
        query_id = databricks_sql_query.demo_query.id
      }
      parameters = {
        "key1" : "value1"
      }
    }
  }
  task {
    task_key = "alert"
    depends_on {
      task_key = "query"
    }
    sql_task {
      warehouse_id = databricks_sql_endpoint.demo.id
      alert {
        alert_id = databricks_sql_alert.demo_alert.id
        subscriptions {
          user_name = "user@domain.com"
        }
      }
    }
  }
  task {
    task_key = "dashboard"
    depends_on {
      task_key = "query"
    }
    sql_task {
      warehouse_id = databricks_sql_endpoint.demo.id
      dashboard {
        dashboard_id = databricks_sql_dashboard.demo_dashboard.id
        subscriptions {
          user_name = "user@domain.com"
        }
      }
    }
  }
  schedule {
    quartz_cron_expression = "1 1 1 * * ?"
    timezone_id            = "UTC"
  }
}
