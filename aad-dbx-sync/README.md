This gist contains Terraform code that allows to synchronize groups & users from 
AAD into the Databricks workspace, without need to setup SCIM connector.

This is an extended version of initial synchronizer implemented by Serge.

To start, download all .tf files to some place, and create a file `terraform.tfvars` with following content:

```hcl
groups = {
  "My AAD group" = {
    workspace_access = true
    databricks_sql_access = true
    allow_cluster_create = true
    allow_instance_pool_create = false
    admin = false
  },
  "AAD group 2" = {
    .....
  }
}
```


Please store the state in remote location as described in [documentation](https://www.terraform.io/docs/language/state/remote.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | ~> 1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) | resource |
| [databricks_group_member.admins](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_group_member.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member) | resource |
| [databricks_service_principal.sp](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal) | resource |
| [databricks_user.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/user) | resource |
| [azuread_group.admins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principals.spns](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principals) | data source |
| [azuread_users.users](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [databricks_group.admins](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | Map of AAD group names into object describing workspace & Databricks SQL access permissions | <pre>map(object({<br/>    workspace_access           = bool<br/>    databricks_sql_access      = bool<br/>    allow_cluster_create       = bool<br/>    allow_instance_pool_create = bool<br/>    admin                      = bool # if this group for Databricks admins<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->