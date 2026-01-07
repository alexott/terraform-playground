# Setting Git credential for Databricks Service Principal on AWS or GCP

This directory contains an example of how we can create a Databricks Service Principal on AWS or GCP and set a Git credential (token) for it so we can perform operations such as create repository, update it, or run job from Git.

Notes: 

* On Azure we can use Azure active directory client ID/secret to authentication SP directly.
* On all clouds we can directly use service principal + its secret created via account console.

## Usage

* Fill the `terraform.tfvars` file with necessary variables (supported values for `git_service` are listed in the [REST API docs](https://docs.databricks.com/api/workspace/gitcredentials/create)):

```hcl
sp_name      = "TF Test example"
git_service  = "gitHub"
git_username = "test"
git_token    = "gh...."
```

* Set [authentication for your main provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication) (lines 9-10) or use environment variables. 

* Run `terraform plan` & `terraform apply`.


## How it works

1. We're creating a service principal using the provider instance declared on lines 9-10.
1. After that we're creating a personal access token for the service principal and use this token to configure another provider instance (lines 14-19).  We're using `databricks_current_config` data source to fetch URL of the current Databricks workspace.
1. We're using provider instance created for service principal to set Git credential.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.37.1 |
| <a name="provider_databricks.sp"></a> [databricks.sp](#provider\_databricks.sp) | 1.37.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_git_credential.sp](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/git_credential) | resource |
| [databricks_obo_token.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/obo_token) | resource |
| [databricks_service_principal.sp](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal) | resource |
| [databricks_current_config.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/current_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_git_service"></a> [git\_service](#input\_git\_service) | Name of the Git service | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | Git token for Service Principal to use | `string` | n/a | yes |
| <a name="input_git_username"></a> [git\_username](#input\_git\_username) | Name of the Git user | `string` | n/a | yes |
| <a name="input_sp_name"></a> [sp\_name](#input\_sp\_name) | Name of the service principal to create | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->