variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "rg_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "rg_location" {
  type        = string
  description = "Azure Location"
}

variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the resources"
  default     = {}
}

# Could be specified as described in the documentation
# https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoint-policies-overview#configuration
variable "uc_storage_account_ids" {
  type        = list(string)
  description = "Azure Storage Account IDs for the UC Regional policy"
}

variable "dbfs_storage_account_name" {
  type        = string
  description = "Azure Storage Account Name for the DBFS storage account"
  default     = ""
}

variable "managed_resource_group_name" {
  type        = string
  description = "(Optional) The name of the resource group where Azure should place the managed Databricks resources"
  default     = ""
}

variable "spoke_vnet_address_space" {
  type        = string
  description = "(Required) The address space for the spoke Virtual Network"
}

variable "databricks_workspace_name" {
  type        = string
  description = "Name of Databricks workspace"
  default     = ""
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space for private Databricks subnet"
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space for public Databricks subnet"
}

variable "service_endpoints" {
  type        = list(string)
  description = "Service endpoints to associate with subnets"
  default = [
    "Microsoft.EventHub",
    "Microsoft.Storage",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.Sql"
  ]
}

