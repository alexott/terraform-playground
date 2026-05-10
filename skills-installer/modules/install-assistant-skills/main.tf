terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
    }
  }
}

data "databricks_current_user" "me" {}

locals {
  skills_root = pathexpand(var.skills_source_dir)

  # Parent folder for user-scoped installs: optional override, otherwise /Users/{databricks_current_user.user_name}.
  effective_user_root = trimspace(var.username) != "" ? "/Users/${trimspace(var.username)}" : "/Users/${data.databricks_current_user.me.user_name}"

  # First-level subdirectories that contain SKILL.md (Terraform-native scan).
  skill_md_matches = try(fileset(local.skills_root, "*/SKILL.md"), [])
  skill_names      = sort(distinct([for p in local.skill_md_matches : split("/", p)[0]]))

  workspace_skills_root = var.global ? "/Workspace/.assistant/skills" : "${local.effective_user_root}/.assistant/skills"

  assistant_paths = var.global ? [
    "/Workspace/.assistant",
    "/Workspace/.assistant/skills",
    ] : [
    "${local.effective_user_root}/.assistant",
    "${local.effective_user_root}/.assistant/skills",
  ]

  all_files = length(local.skill_names) == 0 ? [] : flatten([
    for sn in local.skill_names : [
      for rel in fileset("${local.skills_root}/${sn}", "**") : {
        skill    = sn
        rel_path = rel
      }
    ]
  ])

  # Parent directories needed for nested files (relative paths with '/').
  nested_skill_dirs = flatten([
    for f in local.all_files : [
      for i in range(1, length(split("/", f.rel_path))) :
      "${local.workspace_skills_root}/${f.skill}/${join("/", slice(split("/", f.rel_path), 0, i))}"
    ]
  ])

  skill_root_dirs = [for sn in local.skill_names : "${local.workspace_skills_root}/${sn}"]

  all_workspace_directories = distinct(concat(
    local.assistant_paths,
    local.skill_root_dirs,
    local.nested_skill_dirs
  ))

  sorted_workspace_directories = sort(local.all_workspace_directories)

  workspace_files = {
    for f in local.all_files : "${f.skill}/${f.rel_path}" => f
  }
}

resource "databricks_directory" "skills_paths" {
  for_each = toset(local.sorted_workspace_directories)
  path     = each.key
}

resource "databricks_workspace_file" "skill_file" {
  for_each = local.workspace_files

  path   = "${local.workspace_skills_root}/${each.value.skill}/${each.value.rel_path}"
  source = abspath("${local.skills_root}/${each.value.skill}/${each.value.rel_path}")

  depends_on = [databricks_directory.skills_paths]
}
