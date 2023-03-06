terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "databricks" {
}

provider "azurerm" {
  features {}
}

variable "kv_name" {
  type        = string
  description = "Name of the Azure Key Vault"
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group of Azure Key Vault"
}

variable "db_secret_scope" {
  type        = string
  description = "Name for the Databricks Secret Scope"
}


data "azurerm_key_vault" "this" {
  name                = var.kv_name
  resource_group_name = var.rg_name
}


data "azurerm_key_vault_secrets" "this" {
  key_vault_id = data.azurerm_key_vault.this.id
}

locals {
  secret_names = toset(data.azurerm_key_vault_secrets.this.names)
}

data "azurerm_key_vault_secret" "this" {
  for_each     = local.secret_names
  name         = each.key
  key_vault_id = data.azurerm_key_vault.this.id
}

resource "databricks_secret_scope" "this" {
  name = var.db_secret_scope
}

resource "databricks_secret" "this" {
  for_each     = local.secret_names
  key          = each.key
  string_value = data.azurerm_key_vault_secret.this[each.key].value
  scope        = databricks_secret_scope.this.id
}
