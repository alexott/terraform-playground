variable "active_region" {
  description = "If pipeline in current region is active"
  type        = bool
}

variable "pipeline_name" {
  description = "Name of DLT pipeline"
  type        = string
  # TODO: we can add default name for the specific pipeline
}

variable "pipeline_target" {
  description = "Name of database"
  type        = string
  default     = "datalake"
}

variable "pipeline_edition" {
  description = "DLT Edition to use"
  type        = string
  default     = "CORE"
}

variable "pipeline_storage" {
  description = "Storage location for DLT pipeline data"
  type        = string
}

variable "notebooks" {
  description = "List of notebook names in DLT pipeline"
  type        = list(string)
}

variable "notebooks_directory" {
  description = "Destination directory in workspace"
  type        = string
}

