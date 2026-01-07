# Example of configuring Azure Storage Firewall with data from Network Connectivity Config (NCC)

This folder contains a Terraform demo of creating [databricks_mws_network_connectivity_config](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_network_connectivity_config) and using its information to configure access to the Azure Storage account. To allow access to the data from Serverless Databricks services we need to correspondingly configure storage account. 

To use, create `terraform.tfvars` file with the following variables:

`account_id` - Azure Databricks Account ID
`rg_name` - Resource group for storage account
`location` - Location of storage account and NCC (use lower-case Azure region name)
`storage_name` - Storage account name

Then follow the standard `terraform init`, `terraform plan`, `terraform apply`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.112.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.48.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [databricks_mws_network_connectivity_config.ncc](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_network_connectivity_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Azure Databricks Account ID | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of storage account | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group for storage account | `string` | n/a | yes |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | Storage account name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | n/a |
<!-- END_TF_DOCS -->