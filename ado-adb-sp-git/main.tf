terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.78.0"
    }
  }
}

provider "azuread" {
}

provider "databricks" {
  host                = var.databricks_host
  azure_client_id     = var.entra_client_id
  azure_client_secret = var.entra_client_secret
  azure_tenant_id     = var.entra_tenant_id
}
