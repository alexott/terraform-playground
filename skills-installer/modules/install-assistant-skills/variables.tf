variable "skills_source_dir" {
  type        = string
  description = "Local directory whose immediate subdirectories are scanned; only subdirectories containing SKILL.md at that level are installed."
}

variable "global" {
  type        = bool
  description = "If true, install under /Workspace/.assistant/skills/. If false, install under the current user's home (see username)."
  default     = false
}

variable "username" {
  type        = string
  description = "Optional. Workspace user folder name under /Users/ (e.g. user@example.com). When empty, uses databricks_current_user.user_name."
  default     = ""
}
