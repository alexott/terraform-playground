locals {
  tags = {
    Owner       = "alexey.ott@databricks.com"
    RemoveAfter = "2023-10-21"
  }
  name_prefix = "tfdemo-aott"
  location    = "westeurope"

  hub_cidr      = "10.0.0.0/16"
  hub_vnet_name = "hub-vnet"

  dev_cidr      = "10.1.0.0/16"
  dev_vnet_name = "dev-vnet"

  prod_cidr      = "10.2.0.0/16"
  prod_vnet_name = "prod-vnet"
}



