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
