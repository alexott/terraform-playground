variable "resource_group_name" {
  type        = string
  description = "Name of existing resource group to which deploy Hub VNet"
}

variable "resource_group_location" {
  type        = string
  description = "Location of existing resource group to which deploy Hub VNet"
}

variable "vnet_cidrs" {
  type        = list(string)
  description = "List of network ranges for Hub VNet"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Hub VNet"
}

variable "tags" {
  description = "Optional tags to attach to the Hub VNet"
  default     = {}
}