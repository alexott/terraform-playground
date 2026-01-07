# Example of using Databricks modules to provision Azure Databricks workspace

This folder contains the code that demonstrates the use of `adb-lakehouse` module from [Databricks Terraform modules](https://registry.terraform.io/modules/databricks/examples/databricks/latest) to provision an Azure Databricks workspace, and then assign a Unity Catalog metastore to it.

How to use:

* Modify `terraform.tfvars`
* `terraform init`
* `terraform apply`


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adb_lakehouse"></a> [adb\_lakehouse](#module\_adb\_lakehouse) | databricks/examples/databricks//modules/adb-lakehouse | 0.2.15 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databricks_workspace_name"></a> [databricks\_workspace\_name](#input\_databricks\_workspace\_name) | Name of Databricks workspace | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | (Required) The name of the project environment associated with the infrastructure to be managed by Terraform | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location for the resources in this module | `string` | n/a | yes |
| <a name="input_private_subnet_address_prefixes"></a> [private\_subnet\_address\_prefixes](#input\_private\_subnet\_address\_prefixes) | Address space for private Databricks subnet | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Required) The name of the project associated with the infrastructure to be managed by Terraform | `string` | n/a | yes |
| <a name="input_public_subnet_address_prefixes"></a> [public\_subnet\_address\_prefixes](#input\_public\_subnet\_address\_prefixes) | Address space for public Databricks subnet | `list(string)` | n/a | yes |
| <a name="input_spoke_resource_group_name"></a> [spoke\_resource\_group\_name](#input\_spoke\_resource\_group\_name) | (Required) The name of the Resource Group to create | `string` | n/a | yes |
| <a name="input_spoke_vnet_address_space"></a> [spoke\_vnet\_address\_space](#input\_spoke\_vnet\_address\_space) | (Required) The address space for the spoke Virtual Network | `string` | n/a | yes |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | (Optional) Creates resource group if set to true (default) | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) Map of tags to attach to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | n/a |
<!-- END_TF_DOCS -->