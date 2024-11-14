variable "resource_group_name" {
  type        = string
  description = "Name of existing resource group to which deploy a Spoke VNet"
}

variable "resource_group_location" {
  type        = string
  description = "Location of existing resource group to which deploy a Spoke VNet"
}

variable "vnet_cidrs" {
  type        = list(string)
  description = "List of network ranges for Spoke VNet"
}

variable "plsubnet_cidrs" {
  type        = list(string)
  description = "List of network ranges for Private Link Subnet"
}

variable "plsubnet_name" {
  type        = string
  description = "Name of Private Link Subnet to create"
  default     = "privatelink-subnet"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the Hub VNet to peer with"
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the Hub VNet to peer with"
}

variable "hub_rg_name" {
  type        = string
  description = "Name of the resource group holding Hub VNet"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Spoke VNet"
}

variable "tags" {
  description = "Optional tags to attach to the Spoke VNet"
  default     = {}
}