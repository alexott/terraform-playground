variable "databricks_host" {
  type        = string
  description = "Hostname of Azure Databricks Workspace"
}

variable "entra_client_id" {
  type        = string
  description = "Client ID of existing service principal in Entra ID"
}

variable "entra_client_secret" {
  type        = string
  description = "Client Secret of existing service principal in Entra ID"
}

variable "entra_tenant_id" {
  type        = string
  description = "Entra Tenant ID"
}

variable "ado_repo_url" {
  type        = string
  description = "HTTPS URL of a Git repository in Azure DevOps"
}
