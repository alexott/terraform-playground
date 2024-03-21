data "azurerm_databricks_workspace" "this" {
  name                = var.ws_name
  resource_group_name = var.rg_name
}


resource "databricks_token" "pat" {
  comment          = "ADF (${var.adf_name})"
  lifetime_seconds = 60 * 60 * 24 * 30
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_current_user" "me" {
}

resource "databricks_instance_pool" "adf" {
  instance_pool_name                    = "Smallest Nodes for ADF"
  min_idle_instances                    = 0
  max_capacity                          = 20
  idle_instance_autotermination_minutes = 10
  node_type_id                          = data.databricks_node_type.smallest.id
  preloaded_spark_versions              = [data.databricks_spark_version.latest_lts.id]
}

resource "databricks_service_principal" "adf_mi" {
  display_name         = "${var.adf_name} managed identity"
  application_id       = data.azuread_service_principal.adf.client_id
  allow_cluster_create = true
}

resource "databricks_permissions" "adf_pool_usage" {
  instance_pool_id = databricks_instance_pool.adf.id

  access_control {
    service_principal_name = databricks_service_principal.adf_mi.application_id
    permission_level       = "CAN_ATTACH_TO"
  }
}

# data "databricks_group" "admins" {
#   display_name = "admins"
# }

# resource "databricks_group_member" "sp_is_admin" {
#   group_id  = data.databricks_group.admins.id
#   member_id = databricks_service_principal.sp.id
# }


resource "databricks_notebook" "adf_notebook" {
  content_base64 = base64encode(<<-EOT
    # created from ${abspath(path.module)}
    display(spark.range(10))
    EOT
  )
  path     = "${data.databricks_current_user.me.home}/TFNotebooks/ADFTest"
  language = "PYTHON"
}

resource "databricks_permissions" "adf_notebook_usage" {
  notebook_path = databricks_notebook.adf_notebook.path

  access_control {
    service_principal_name = databricks_service_principal.adf_mi.application_id
    permission_level       = "CAN_RUN"
  }
}
