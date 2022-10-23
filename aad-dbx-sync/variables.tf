# we can use optional + defaults, then it would be easier to use, but it's an experimental feature
variable "groups" {
  description = "Map of AAD group names into object describing workspace & Databricks SQL access permissions"
  type = map(object({
    workspace_access = bool
    databricks_sql_access = bool
    allow_cluster_create = bool
    allow_instance_pool_create = bool
    admin = bool  # if this group for Databricks admins
  }))
}

# Create a variable in the terraform.tfvars with following content
#  fields are false by default
# groups = {
#   "AAD Group Name" = {
#     workspace_access = true
#     allow_sql_analytics_access = false
#     allow_cluster_create = false
#     allow_instance_pool_create = false
#     admin = false
#   }
# }
