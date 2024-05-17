resource "azurerm_key_vault" "this" {
  name                = "${var.prefix}-keyvault"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"

  enable_rbac_authorization  = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  tags = var.tags
}

resource "azurerm_key_vault_key" "notebooks" {
  depends_on = [azurerm_role_assignment.terraform]

  name         = "${var.prefix}-notebooks-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_key" "dbfs" {
  depends_on = [azurerm_role_assignment.terraform]

  name         = "${var.prefix}-dbfs-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_key" "disks" {
  depends_on = [azurerm_role_assignment.terraform]

  name         = "${var.prefix}-disks-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

# See https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration
resource "azurerm_role_assignment" "terraform" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator" # This could be reduced to "Key Vault Crypto Officer" and "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# for DBFS encryption
resource "azurerm_role_assignment" "dbfs" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.this.storage_account_identity.0.principal_id
}

# for Managed Disks encryption
resource "azurerm_role_assignment" "disks" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.this.managed_disk_identity.0.principal_id
}

# will be used for next resource
data "azuread_service_principal" "databricks" {
  client_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
}

# For notebooks encryption
resource "azurerm_role_assignment" "managed_keys" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azuread_service_principal.databricks.object_id
}

resource "azurerm_role_assignment" "managed_secrets" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_service_principal.databricks.object_id
}

