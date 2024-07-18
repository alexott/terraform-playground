resource "databricks_mws_network_connectivity_config" "ncc" {
  name   = "ncc-for-${var.rg_name}"
  region = var.location
}
