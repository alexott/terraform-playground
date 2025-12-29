# Workspace Customization - Prod Module

Configures a Databricks workspace with production-grade security settings, including disabled personal access tokens, IP access lists, and service principal admin assignments.

## Usage

```hcl
module "ws_customize" {
  source    = "../modules/ws-customize-prod"
  admin_sps = ["00000000-0000-0000-0000-000000000000"]
  
  providers = {
    databricks = databricks.workspace
  }
}
```

## Resources Created

- `databricks_workspace_conf` - Workspace configuration settings
- `databricks_ip_access_list` - IP block list
- `databricks_user` - Admin users provisioned in the workspace (if any)
- `databricks_service_principal` - Admin service principals
- `databricks_group_member` - Admin group memberships

## Configuration Applied

### Workspace Settings

| Setting | Value |
|---------|-------|
| enableTokensConfig | `false` |
| enableIpAccessLists | `true` |

### IP Access Lists

- Block list configured for restricted networks (e.g., `192.168.1.0/24`)

## Notes

- Personal access token generation is **disabled** in production environments
- Service principals are the recommended admin identity for production
- Use `admin_sps` with Azure AD application IDs for automation accounts
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