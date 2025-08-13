variable "rg_name" {
  description = "Name of the resource group to deploy resources to"
  type        = string
}

variable "rg_location" {
  description = "Location of the resource group to deploy resources to"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for the name of all resources"
  type        = string
}

variable "pe_subnet_cidr" {
  description = "CIDR for the PE subnet"
  type        = string
  default     = "100.64.253.0/24"
}

variable "utility_subnet_cidr" {
  description = "CIDR for the utility subnet"
  type        = string
  default     = "100.64.254.0/24"
}

variable "bastion_subnet_cidr" {
  description = "CIDR for the bastion subnet"
  type        = string
  default     = "100.64.255.0/26"
}

variable "vnet_cidr" {
  description = "Address CIDR for the virtual network"
  type        = string
  default     = "100.64.0.0/10"
}

variable "host_subnet_cidr" {
  description = "Address CIDR for the host subnet"
  type        = string
  default     = "100.64.0.0/20"
}

variable "container_subnet_cidr" {
  description = "Address CIDR for the container subnet"
  type        = string
  default     = "100.64.16.0/20"
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "firewall_vnet_cidr" {
  description = "CIDR for the firewall VNet. It's expected to be a /25 subnet"
  type        = string
  # default     = "10.0.1.0/25"
}

variable "firewall_subnet_cidr" {
  description = "CIDR for the firewall subnet. It's expected to be a /26 subnet"
  type        = string
  # default     = "10.0.1.0/26"
}

variable "firewall_management_subnet_cidr" {
  description = "CIDR for the firewall management subnet. It's expected to be a /26 subnet"
  type        = string
  # default     = "10.0.1.64/26"
}

variable "hub_firewall_ip" {
  description = "IP address for the hub firewall"
  type        = string
}

variable "hub_vnet_id" {
  description = "ID of the hub VNet"
  type        = string
}

