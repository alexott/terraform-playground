module "dlt_xs" {
  source       = "./dlt-module/"
  name         = "DLT (XS T-Shirt Size, ${data.databricks_current_user.me.alphanumeric})"
  storage_path = "/tmp/dlt_xs"
  notebooks    = [databricks_notebook.dlt_sql.id, databricks_notebook.dlt_python.id]
  development  = true
  t_shirt_size = "xs_fixed"
}


module "dlt_m_autoscaling" {
  source       = "./dlt-module/"
  name         = "DLT (XS T-Shirt Size, ${data.databricks_current_user.me.alphanumeric})"
  storage_path = "/tmp/dlt_xs"
  notebooks    = [databricks_notebook.dlt_sql.id, databricks_notebook.dlt_python.id]
  development  = true
  t_shirt_size = "m_autoscaling"
}
