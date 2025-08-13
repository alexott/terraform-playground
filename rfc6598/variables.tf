variable "subscription_id" {
  description = "Azure subscription ID to use"
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group to deploy resources to"
  type        = string
}

variable "rg_location" {
  description = "Location of the resource group to deploy resources to"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for the resource names"
  type        = string
}

variable "hub_vnet_cidr" {
  description = "CIDR for the hub VNet"
  type        = string
}

variable "hub_firewall_subnet_cidr" {
  description = "CIDR for the hub firewall subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

# Take from https://learn.microsoft.com/en-us/azure/databricks/resources/ip-domain-region#control-plane-ip-addresses
variable "metastores" {
  description = "List of Hive metastore hosts"
  type        = list(string)
}

variable "eventhubs" {
  description = "List of event hubs hosts"
  type        = list(string)
}

variable "scc_relay" {
  description = "List of SCC relay hosts"
  type        = list(string)
}

variable "webapp_ips" {
  description = "List of webapp IPs"
  type        = list(string)
}

variable "databricks_fqdns" {
  description = "List of Databricks FQDNs (storage accounts, etc.)"
  type        = list(string)
}

variable "additional_allowed_fqdns" {
  description = "List of additional allowed FQDNs"
  type        = list(string)
  default     = []
}