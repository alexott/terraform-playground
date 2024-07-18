# Example of configuring Azure Storage Firewall with data from Network Connectivity Config (NCC)

This folder contains a Terraform demo of creating [databricks_mws_network_connectivity_config](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_network_connectivity_config) and using its information to configure access to the Azure Storage account. To allow access to the data from Serverless Databricks services we need to correspondingly configure storage account. 

To use, create `terraform.tfvars` file with the following variables:

`account_id` - Azure Databricks Account ID
`rg_name` - Resource group for storage account
`location` - Location of storage account and NCC (use lower-case Azure region name)
`storage_name` - Storage account name

Then follow the standard `terraform init`, `terraform plan`, `terraform apply`
