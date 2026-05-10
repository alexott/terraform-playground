output "workspace_skills_root" {
  description = "Databricks workspace path where skills were installed."
  value       = local.workspace_skills_root
}

output "skill_names" {
  description = "Skill directory names installed (immediate children of skills_source_dir that contained SKILL.md)."
  value       = local.skill_names
}

output "workspace_file_paths" {
  description = "Workspace paths for uploaded files."
  value       = [for f in local.all_files : "${local.workspace_skills_root}/${f.skill}/${f.rel_path}"]
}
