locals {
  config = yamldecode(file(var.config_file))

  uc_admin_workspace = local.config.config.uc_admin_workspace
}


# output "uc_admin_workspace" {
#   value = local.uc_admin_workspace
# }

# output "config" {
#   value = local.config
# }
