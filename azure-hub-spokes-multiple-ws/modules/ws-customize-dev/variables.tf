variable "admin_users" {
  type        = list(string)
  description = "List of additional admin users"
  default     = []
}

variable "admin_sps" {
  type        = list(string)
  description = "List of additional admin service principals"
  default     = []
}