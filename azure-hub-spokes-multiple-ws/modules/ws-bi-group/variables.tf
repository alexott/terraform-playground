variable "group_name" {
  type        = string
  description = "Name of the group to create"
}

variable "user_names" {
  type        = list(string)
  description = "List of users to create in the specified group"
  default     = []
}

variable "warehouse_size" {
  type        = string
  default     = "2X-Small"
  description = "Size of the SQL warehouse to create"
}

variable "tags" {
  default     = {}
  description = "Optional tags to add to resources"
}

variable "serverless_enabled" {
  type        = bool
  default     = true
  description = "If it should be Serverless SQL warehouse. If enabled, it's incompatible with CLASSIC SKU"
}

variable "warehouse_sku" {
  type        = string
  default     = "PRO"
  description = "SQL Warehouse SKU (PRO or CLASSIC)"
}

variable "auto_stop_mins" {
  default     = 5
  description = "Autoterminate after N minutes"
}
