resource "azurerm_storage_account" "this" {
  name                     = var.storage_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id

  default_action             = "Allow"
  virtual_network_subnet_ids = local.uniq_storage_subnets
}

locals {
  all_storage_subnets = [for conf in databricks_mws_network_connectivity_config.ncc.egress_config :
    [for rule in conf.default_rules :
      [for se_rule in rule.azure_service_endpoint_rule :
        se_rule.subnets if contains(se_rule.target_services, "AZURE_BLOB_STORAGE")
      ]
    ]
  ]
  uniq_storage_subnets = distinct(flatten(local.all_storage_subnets))
}

output "rules" {
  value = databricks_mws_network_connectivity_config.ncc
}

