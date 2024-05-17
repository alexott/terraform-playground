resource "databricks_secret_scope" "kv" {
  name = "test"

  keyvault_metadata {
    resource_id = azurerm_key_vault.this.id
    dns_name    = azurerm_key_vault.this.vault_uri
  }

  depends_on = [azurerm_databricks_workspace.this]
}


# Test data to check from Databricks workspace
# Create a notebook in the Databricks workspace, and issue the following command to read a secret:
# dbutils.secrets.get("test", "test")
resource "azurerm_key_vault_secret" "this" {
  name         = "test"
  value        = "42"
  key_vault_id = azurerm_key_vault.this.id
}
