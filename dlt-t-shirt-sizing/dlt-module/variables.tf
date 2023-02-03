variable "storage_path" {
  type        = string
  description = "Path to ADLS location to keep DLT data (abfss://...)"
}

variable "development" {
  type        = bool
  description = "If the pipeline is in development mode"
  default     = false
}

variable "continuous" {
  type        = bool
  description = "If the pipeline should run in continuos mode"
  default     = false
}

variable "name" {
  type        = string
  description = "Name of the DLT pipeline"
}

variable "notebooks" {
  type        = list(string)
  description = "List of notebook paths"
  default     = []
}

variable "files" {
  type        = list(string)
  description = "List of notebook paths"
  default     = []
}

variable "t_shirt_size" {
  type        = string
  description = "T-shirt cluster size (xs_fixed, xs_autoscaling, ...)"
  default     = "xs_fixed"
}

# variable "" {
#   type = string
#   description = ""
# }
