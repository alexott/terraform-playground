# DBX Global policy - it could be defined globally for all regions
resource "azurerm_subnet_service_endpoint_storage_policy" "dbx" {
  name                = "${var.prefix}-DBX-Global"
  resource_group_name = var.rg_name
  location            = var.rg_location
  tags                = var.tags
  definition {
    name        = "${var.prefix}-DBX-Global"
    description = "DBX Global policy"
    service     = "Global"
    service_resources = [
      "/services/Azure/Databricks",
    ]
  }
}

# UC Regional policy - it could be defined for each region separately
resource "azurerm_subnet_service_endpoint_storage_policy" "uc" {
  name                = "${var.prefix}-UC-Regional-${var.rg_location}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  tags                = var.tags
  definition {
    name              = "${var.prefix}-UC-Regional-${var.rg_location}"
    description       = "UC Regional policy"
    service           = "Microsoft.Storage"
    service_resources = var.uc_storage_account_ids
  }
}

# policy for DBFS storage account should be created before workspace is created
# as we don't have a separate resource for association of policy with the subnet
# TODO: create a GH issue for this
resource "azurerm_subnet_service_endpoint_storage_policy" "dbfs" {
  name                = "${var.prefix}-dbfs-policy"
  resource_group_name = var.rg_name
  location            = var.rg_location
  tags                = var.tags
  definition {
    name              = "${var.prefix}-dbfs-policy"
    description       = "DBFS policy"
    service           = "Microsoft.Storage"
    service_resources = [local.dbfs_storage_account_id]
  }
}