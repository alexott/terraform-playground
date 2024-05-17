variable "rg_name" {
  description = "Name of existing resource group to deploy all resources"
  type        = string
}

variable "prefix" {
  description = "The Prefix used for all resources in this example"
  type        = string
}

variable "vnet_address_space" {
  description = "VNet Address Space"
  type        = list(string)
}

variable "private_subnet_address_prefixes" {
  description = "List of IP ranges for private (container) subnet"
  type        = list(string)
}

variable "public_subnet_address_prefixes" {
  description = "List of IP ranges for publi (host) subnet"
  type        = list(string)
}

variable "tags" {
  description = "optional tags to add to all resources"
  default     = {}
  type        = map(any)
}
