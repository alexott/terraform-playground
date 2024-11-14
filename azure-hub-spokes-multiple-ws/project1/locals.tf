locals {
  name_prefix         = "tfdemo-aott"
  resource_group_name = "${local.name_prefix}-prod"
  kv_rg_name = "alexott-fe-rg"
  keyvault_name = "aott-kv"
  aad_tenant = "9f37a392-f0ae-4280-9796-f1864a10effc"
}
