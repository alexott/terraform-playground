# Workspace Data Engineering Group Module

Creates a Data Engineering team group in a Databricks workspace with full workspace access, shared cluster, cluster policy, and SQL warehouse.

## Usage

```hcl
module "de_team" {
  source     = "../modules/ws-de-group"
  group_name = "Data Engineering Team"
  user_names = ["engineer1@domain.com", "engineer2@domain.com"]
  tags       = { CostCenter = "Engineering" }
  
  providers = {
    databricks = databricks.workspace
  }
}
```

## Resources Created

- `databricks_group` - Group with workspace and SQL access
- `databricks_user` - Users provisioned in the workspace
- `databricks_group_member` - User-to-group memberships
- `databricks_cluster` - Shared auto-scaling cluster for the team
- `databricks_cluster_policy` - Fair use policy limiting DBUs and clusters per user
- `databricks_sql_endpoint` - Serverless PRO SQL warehouse
- `databricks_permissions` - CAN_MANAGE permissions on cluster and SQL warehouse, CAN_USE on cluster policy

## Features

- **Full Workspace Access**: Group configured for interactive workspace usage
- **Shared Cluster**: Auto-scaling cluster (1-10 workers) with 20-min auto-termination
- **Cluster Policy**: Fair use policy with:
  - Max 2 clusters per user
  - Max 10 DBUs per hour
  - Fixed driver node type
  - Team tagging
- **Serverless SQL Warehouse**: PRO tier with auto-scaling (1-3 clusters)
- **Self-service**: Team members can manage their own resources

## Notes

- The shared cluster uses the smallest available node type with local disk
- The cluster policy enforces cost controls and proper tagging
- SQL warehouse is configured for serverless PRO tier

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
| [databricks_cluster.team_cluster](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_cluster_policy.fair_use](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) | resource |
| [databricks_group_member.data_eng_member](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_permissions.can_manage_sql_endpoint](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.can_manage_team_cluster](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.can_use_cluster_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |
| [databricks_user.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/user) | resource |
| [databricks_node_type.smallest](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |
| [databricks_spark_version.latest_lts](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/spark_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of the group to create | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags applied to all resources created | `map(string)` | `{}` | no |
| <a name="input_user_names"></a> [user\_names](#input\_user\_names) | List of users to create in the specified group | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->