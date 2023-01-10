variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "client_id" {
  type        = string
  description = "Azure AD Service Principal Client ID"
}

variable "sp_secret_scope_name" {
  type        = string
  description = "Name of the secret scope keeping Service Principal client secret"
}

variable "sp_secret_secret_name" {
  type        = string
  description = "Name of the secret inside secret scope keeping Service Principal client secret"
}


variable "abfss_path" {
  type        = string
  description = "Path to ADLS location to keep DLT data (abfss://...)"
}

# variable "" {
#   type = string
#   description = ""
# }

