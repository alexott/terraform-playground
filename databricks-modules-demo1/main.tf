locals {
  managed_resource_group_name = var.managed_resource_group_name == "" ? "${var.databricks_workspace_name}-managed-rg" : var.managed_resource_group_name
}

module "adb_lakehouse" {
  source                          = "databricks/examples/databricks//modules/adb-lakehouse"
  version                         = "0.2.13"
  project_name                    = var.project_name
  environment_name                = var.environment_name
  location                        = var.location
  spoke_vnet_address_space        = var.spoke_vnet_address_space
  spoke_resource_group_name       = var.spoke_resource_group_name
  managed_resource_group_name     = local.managed_resource_group_name
  databricks_workspace_name       = var.databricks_workspace_name
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  storage_account_names           = []
  key_vault_name                  = ""
  tags                            = var.tags
}

# This will be uncommented as part of the demo

# module "uc_idf_assignment" {
#   source       = "databricks/examples/databricks//modules/uc-idf-assignment"
#   version      = "0.2.13"
#   workspace_id = module.adb_lakehouse.workspace_id
#   metastore_id = var.metastore_id

#   providers = {
#     databricks = databricks.account
#   }
# }
