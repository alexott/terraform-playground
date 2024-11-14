data "azurerm_databricks_workspace" "ws1" {
  name                = "${local.resource_group_name}-ws1"
  resource_group_name = local.resource_group_name
}

provider "databricks" {
  alias = "ws1"
  host  = data.azurerm_databricks_workspace.ws1.workspace_url
}

module "ws1_customize" {
  source    = "../modules/ws-customize-prod"
  admin_sps = ["c1b2a35b-87c4-481a-a0fb-0508be621957"]
  providers = {
    databricks = databricks.ws1
  }
}

# We can map groups explicitly, or we can use some kind of metadata-driven approach,
# when groups mapping is loaded from some config file, and then 

module "ws1_group_1_bi" {
  source     = "../modules/ws-bi-group"
  group_name = "BI Group 1"
  user_names = ["bi_user1@domain.com", "bi_user2@domain.com"]
  providers = {
    databricks = databricks.ws1
  }
}

module "ws1_group_2_bi" {
  source     = "../modules/ws-bi-group"
  group_name = "BI Group 2"
  user_names = ["bi_user3@domain.com", ]
  providers = {
    databricks = databricks.ws1
  }
}

# Setup jobs, etc.