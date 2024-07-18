variable "account_id" {
  type        = string
  description = "Azure Databricks Account ID"
}

variable "rg_name" {
  type        = string
  description = "Resource group for storage account"
}

variable "location" {
  type        = string
  description = "Location of storage account"
}

variable "storage_name" {
  type        = string
  description = "Storage account name"
}
