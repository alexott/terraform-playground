data "azurerm_key_vault" "this" {
  name                = var.akv_name
  resource_group_name = var.rg_name
}

resource "azurerm_key_vault_secret" "pat" {
  name         = "${var.adf_name}-pat"
  value        = databricks_token.pat.token_value
  key_vault_id = data.azurerm_key_vault.this.id
}

resource "azurerm_key_vault_access_policy" "adf" {
  key_vault_id = data.azurerm_key_vault.this.id
  tenant_id    = azurerm_data_factory.this.identity[0].tenant_id
  object_id    = azurerm_data_factory.this.identity[0].principal_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}
