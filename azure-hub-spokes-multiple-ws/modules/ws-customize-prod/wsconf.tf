resource "databricks_workspace_conf" "this" {
  custom_config = {
    "enableTokensConfig" : false,
    "enableIpAccessLists" : true,
  }
}

resource "databricks_ip_access_list" "block-list" {
  label     = "block"
  list_type = "BLOCK"
  ip_addresses = [
    "192.168.1.0/24"
  ]
  depends_on = [databricks_workspace_conf.this]
}