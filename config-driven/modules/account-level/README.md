# Account-Level Module

This module manages Databricks Unity Catalog resources at the account level, specifically metastore creation and workspace assignments.

## Description

The account-level module handles:

- **Metastore management** - Creates a new metastore or references an existing one based on configuration
- **Workspace assignments** - Assigns the metastore to specified Databricks workspaces

## Usage

This module is called from the root module and requires account-level Databricks provider:

```hcl
module "account_level" {
  source = "./modules/account-level"
  config = local.config
  providers = {
    databricks = databricks.account
  }
}
```

## Configuration

The module expects a configuration object with the following structure:

```yaml
metastore:
  name: "my-metastore"        # Optional, defaults to location value
  location: "westeurope"      # Required - cloud region
  create: true                # Optional, defaults to false
  owner: "Metastore Admins"   # Optional
  workspaces:                 # Optional - list of workspace IDs
    - 1234567890123456
    - 9876543210987654
```

### Configuration options

| Key | Type | Required | Default | Description |
|-----|------|----------|---------|-------------|
| `metastore.name` | string | No | `location` value | Name of the metastore |
| `metastore.location` | string | Yes | - | Cloud region for the metastore |
| `metastore.create` | bool | No | `false` | Whether to create a new metastore |
| `metastore.owner` | string | No | - | Owner of the metastore |
| `metastore.workspaces` | list(number) | No | `[]` | Workspace IDs to assign to the metastore |

## Resources

| Name | Type | Description |
|------|------|-------------|
| `databricks_metastore.this` | resource | Created when `metastore.create = true` |
| `databricks_metastore.this` | data | Looked up when `metastore.create = false` |
| `databricks_metastore_assignment.this` | resource | Workspace-to-metastore assignments |

## Requirements

- Databricks account administrator permissions
- UC Metastore administrator permissions
- Account-level Databricks provider

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
| [databricks_metastore.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore) | resource |
| [databricks_metastore_assignment.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment) | resource |
| [databricks_metastore.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/metastore) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | The config | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metastore_id"></a> [metastore\_id](#output\_metastore\_id) | n/a |
<!-- END_TF_DOCS -->

