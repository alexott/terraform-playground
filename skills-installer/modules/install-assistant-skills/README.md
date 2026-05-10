# install-assistant-skills

Terraform module that uploads **Databricks Assistant–style skills** from a local directory into workspace paths used by the assistant (`.assistant/skills/`).

## What it does

1. **Scans** `skills_source_dir` for **immediate subdirectories** that contain a **`SKILL.md`** file at that level (Terraform `fileset(..., "*/SKILL.md")`). Nested folders without their own top-level `SKILL.md` under the root are not treated as separate skills.
2. **Creates** workspace directories with [`databricks_directory`](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/directory) for `.assistant`, `.assistant/skills`, each skill folder, and any intermediate paths needed for nested files.
3. **Uploads** every file under each matched skill folder with [`databricks_workspace_file`](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_file).

## Install targets

| `global` | Workspace location |
|----------|-------------------|
| `false` (default) | `/Users/<user>/.assistant/skills/<skill>/...` |
| `true` | `/Workspace/.assistant/skills/<skill>/...` |

When `global` is `false`, the user segment is resolved from the [`databricks_current_user`](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/current_user) data source (`user_name`), unless you override it with the module `username` variable (then `/Users/<username>/...` is used).

Local paths support shell-style home expansion via Terraform `pathexpand()` on `skills_source_dir`.

## Requirements

- Workspace-level [`databricks`](https://registry.terraform.io/providers/databricks/databricks/latest/docs) provider configuration (authenticated user or principal that may create workspace objects at the chosen paths).
- `skills_source_dir` must exist at plan time so `fileset` can run.

## Usage

```hcl
module "assistant_skills" {
  source = "./modules/install-assistant-skills"

  skills_source_dir = pathexpand("~/path/to/skills-repo")

  # Optional
  global   = false          # default: user-scoped install
  username = ""             # default: use databricks_current_user.user_name
}

provider "databricks" {
  # profile = "DEFAULT"
}
```

Workspace-wide install:

```hcl
module "assistant_skills" {
  source            = "./modules/install-assistant-skills"
  skills_source_dir = pathexpand("~/path/to/skills-repo")
  global            = true
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `skills_source_dir` | `string` | (required) | Root folder whose **direct** children are candidate skill directories. |
| `global` | `bool` | `false` | If `true`, install under `/Workspace/.assistant/skills/`. |
| `username` | `string` | `""` | If set (after trim), use `/Users/<username>/...`; if empty and `global` is `false`, use `databricks_current_user.user_name`. |

## Outputs

| Name | Description |
|------|-------------|
| `workspace_skills_root` | Workspace path of the skills root (`.assistant/skills`). |
| `skill_names` | List of installed skill directory names. |
| `workspace_file_paths` | Full workspace paths of all uploaded files. |

## Example layout

```text
skills_source_dir/
  my-skill/
    SKILL.md
    references/
      doc.md
  other-skill/
    SKILL.md
```

Both `my-skill` and `other-skill` are uploaded; a folder without `SKILL.md` at its top level under `skills_source_dir` is ignored.
