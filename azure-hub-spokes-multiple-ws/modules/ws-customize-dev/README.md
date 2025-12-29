# Workspace Customization - Dev Module

Configures a Databricks workspace with development-appropriate security settings, including token policies, IP access lists, and admin user assignments.

## Usage

```hcl
module "ws_customize" {
  source      = "../modules/ws-customize-dev"
  admin_users = ["admin1@domain.com", "admin2@domain.com"]
  admin_sps   = ["00000000-0000-0000-0000-000000000000"]
  
  providers = {
    databricks = databricks.workspace
  }
}
```

## Resources Created

- `databricks_workspace_conf` - Workspace configuration settings
- `databricks_ip_access_list` - IP block list
- `databricks_user` - Admin users provisioned in the workspace
- `databricks_service_principal` - Admin service principals
- `databricks_group_member` - Admin group memberships

## Configuration Applied

### Workspace Settings

| Setting | Value |
|---------|-------|
| enableTokensConfig | `true` |
| maxTokenLifetimeDays | `90` |
| enableIpAccessLists | `true` |

### IP Access Lists

- Block list configured for restricted networks (e.g., `192.168.0.0/24`)

## Notes

- Token generation is **enabled** in dev environments with a 90-day maximum lifetime
- Use `admin_users` to add human administrators
- Use `admin_sps` to add service principal administrators (provide the Azure AD application ID)
- The IP block list should be customized for your environment

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_group_member.sp-is-admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_group_member.user-is-admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_ip_access_list.block-list](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/ip_access_list) | resource |
| [databricks_service_principal.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal) | resource |
| [databricks_user.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/user) | resource |
| [databricks_workspace_conf.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_conf) | resource |
| [databricks_group.admins](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_sps"></a> [admin\_sps](#input\_admin\_sps) | List of additional admin service principals | `list(string)` | `[]` | no |
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | List of additional admin users | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->