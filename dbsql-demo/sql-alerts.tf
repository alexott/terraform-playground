resource "databricks_sql_alert" "demo_alert" {
  query_id = databricks_sql_query.demo_query.id
  name     = "Demo Alert"
  rearm    = 3600
  options {
    value          = "500"
    op             = ">"
    column         = "cnt"
    custom_subject = "Alert \"{{ALERT_NAME}}\" changed status to {{ALERT_STATUS}}."
  }
}
