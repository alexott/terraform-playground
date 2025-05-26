location                        = "westeurope"
spoke_resource_group_name       = "alexott-fe-rg"
project_name                    = "perf-test"
environment_name                = "dev"
spoke_vnet_address_space        = "10.0.0.0/16"
private_subnet_address_prefixes = ["10.0.1.0/24"]
public_subnet_address_prefixes  = ["10.0.2.0/24"]
databricks_workspace_name       = "exporter-perf-test"
create_resource_group           = false
tags = {
  Owner       = "alexey.ott@databricks.com",
  RemoveAfter = "2025-05-31",
  Purpose = "TF Scale webinar",
}
# This will be uncommented as part of the demo
# account_id   = "..."
# metastore_id = ".."
