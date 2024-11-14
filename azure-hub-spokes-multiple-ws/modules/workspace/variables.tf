variable "workspace_name" {
  type        = string
  description = "Name of a Databricks workspace to create"
}

variable "resource_group_name" {
  type        = string
  description = "Name of existing resource group to which deploy a Databricks workspace"
}

variable "resource_group_location" {
  type        = string
  description = "Location of existing resource group to which deploy a Databricks workspace"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Spoke VNet"
}

variable "vnet_resource_id" {
  type        = string
  description = "Resource ID of the Spoke VNet"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Network range for public (Host) subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Network range for private (Container) subnet"
}

variable "nsg_resource_id" {
  type        = string
  description = "Resource ID of a NSG to associate subnets with"
}

variable "route_table_resource_id" {
  type        = string
  description = "Resource ID of a route table to associate subnets with"
}

variable "tags" {
  description = "Optional tags to attach to the Spoke VNet"
  default     = {}
}