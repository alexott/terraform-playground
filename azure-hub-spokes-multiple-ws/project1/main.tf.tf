data "azurerm_databricks_workspace" "this" {
  name                = "${local.resource_group_name}-ws1"
  resource_group_name = local.resource_group_name
}

data "azurerm_key_vault" "existing" {
  name                = local.keyvault_name
  resource_group_name = local.kv_rg_name
}

data "azurerm_key_vault_secret" "sp_secret" {
  name         = "alexott-sp-secret"
  key_vault_id = data.azurerm_key_vault.existing.id
}

data "azurerm_key_vault_secret" "sp_id" {
  name         = "alexott-sp-id"
  key_vault_id = data.azurerm_key_vault.existing.id
}

provider "databricks" {
  host  = data.azurerm_databricks_workspace.this.workspace_url
  azure_workspace_resource_id  = data.azurerm_databricks_workspace.this.id
  azure_client_id     = data.azurerm_key_vault_secret.sp_id.value
  azure_client_secret = data.azurerm_key_vault_secret.sp_secret.value
  azure_tenant_id     = local.aad_tenant
}
