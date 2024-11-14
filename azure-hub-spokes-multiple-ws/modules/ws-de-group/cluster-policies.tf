resource "databricks_cluster_policy" "fair_use" {
  name                  = "${var.group_name} Policy"
  max_clusters_per_user = 2
  definition = jsonencode({
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 10
    },
    "driver_node_type_id" : {
      "type" : "fixed",
      "value" : data.databricks_node_type.smallest.id,
      "hidden" : true
    },
    "autoscale.min_workers" : {
      "type" : "fixed",
      "value" : 1,
      "hidden" : true
    },
    "custom_tags.Team" : {
      "type" : "fixed",
      "value" : var.group_name
    }
  })
}

resource "databricks_permissions" "can_use_cluster_policy" {
  cluster_policy_id = databricks_cluster_policy.fair_use.id
  access_control {
    group_name       = databricks_group.this.display_name
    permission_level = "CAN_USE"
  }
}
