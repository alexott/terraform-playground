module "account_level" {
  source = "./modules/account-level"
  config = local.config
  providers = {
    databricks = databricks.account
  }
}

module "metastore_level" {
  source     = "./modules/metastore-level"
  config     = local.config
  depends_on = [module.account_level]
  providers = {
    databricks = databricks.workspace
  }
}


