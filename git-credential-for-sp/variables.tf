variable "git_token" {
  type        = string
  description = "Git token for Service Principal to use"
}

variable "git_username" {
  type        = string
  description = "Name of the Git user"
}

variable "git_service" {
  type        = string
  description = "Name of the Git service"
}

variable "sp_name" {
  type        = string
  description = "Name of the service principal to create"
}
