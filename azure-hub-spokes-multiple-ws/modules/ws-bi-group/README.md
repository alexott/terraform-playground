# Workspace BI Group Module

Creates a Business Intelligence team group in a Databricks workspace with SQL warehouse access and dedicated SQL endpoint.

## Usage

```hcl
module "bi_team" {
  source     = "../modules/ws-bi-group"
  group_name = "BI Team"
  user_names = ["analyst1@domain.com", "analyst2@domain.com"]
  
  # Optional customization
  warehouse_size     = "Small"
  serverless_enabled = true
  warehouse_sku      = "PRO"
  auto_stop_mins     = 10
  
  providers = {
    databricks = databricks.workspace
  }
}
```

## Features

- **SQL-focused Access**: Group configured for Databricks SQL usage
- **Dedicated Warehouse**: Each team gets their own SQL endpoint
- **Serverless Support**: Optional serverless compute for cost efficiency
- **Auto-stop**: Configurable idle timeout to reduce costs

## Resources Created

- `databricks_group` - Group with Databricks SQL access
- `databricks_user` - Users provisioned in the workspace
- `databricks_group_member` - User-to-group memberships
- `databricks_sql_endpoint` - Dedicated SQL warehouse for the team
- `databricks_permissions` - CAN_USE permission on the SQL warehouse

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
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) | resource |
| [databricks_group_member.data_eng_member](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_permissions.endpoint_usage](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |
| [databricks_user.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of the group to create | `string` | n/a | yes |
| <a name="input_auto_stop_mins"></a> [auto\_stop\_mins](#input\_auto\_stop\_mins) | Autoterminate after N minutes | `number` | `5` | no |
| <a name="input_serverless_enabled"></a> [serverless\_enabled](#input\_serverless\_enabled) | If it should be Serverless SQL warehouse. If enabled, it's incompatible with CLASSIC SKU | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to add to resources | `map` | `{}` | no |
| <a name="input_user_names"></a> [user\_names](#input\_user\_names) | List of users to create in the specified group | `list(string)` | `[]` | no |
| <a name="input_warehouse_size"></a> [warehouse\_size](#input\_warehouse\_size) | Size of the SQL warehouse to create | `string` | `"2X-Small"` | no |
| <a name="input_warehouse_sku"></a> [warehouse\_sku](#input\_warehouse\_sku) | SQL Warehouse SKU (PRO or CLASSIC) | `string` | `"PRO"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->