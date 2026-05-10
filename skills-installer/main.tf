terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.114.2"
    }
  }
}

provider "databricks" {
  # Configuration options
}

module "assistant_skills" {
  source = "./modules/install-assistant-skills"

  skills_source_dir = local.skills_dir
  global            = false
  username          = var.databricks_username
}

variable "databricks_username" {
  type        = string
  description = "Optional override for /Users/{name} when module.global is false. Leave empty to use the authenticated user's workspace home."
  default     = ""
}

locals {
  skills_dir = pathexpand("~/work/forks/ai-dev-kit/databricks-skills")
}