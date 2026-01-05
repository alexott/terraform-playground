# Config-Driven Databricks Unity Catalog Management

This Terraform project provides a configuration-driven approach to managing Databricks Unity Catalog resources. Instead of writing Terraform code for each resource, you define your desired state in a YAML configuration file, and the modules handle resource creation and management.

## Why Config-Driven?

Config-driven approaches externalize the definition of resources into configuration files (YAML, JSON, etc.) instead of requiring users to write Terraform code directly.

### Benefits

- **Hide complexity** - Abstract away Terraform implementation details, state management, and provider configuration
- **Lower barrier to entry** - Enable team members who don't know Terraform to manage Unity Catalog resources
- **Enforce standards** - Ensure consistent resource naming, tagging, and security configurations
- **Improve security** - Centralize control over what can be deployed and how

### Use Cases

This approach is particularly valuable for:

1. **Centralized management of resources** - Platform teams managing top-level Unity Catalog objects (metastores, credentials, catalogs) on behalf of the organization
2. **Standardized deployments** - Providing project teams with a "standard" Terraform implementation driven by a simple configuration file

### Trade-offs

| Approach | Pros | Cons |
|----------|------|------|
| **Centralized management** | Simplicity for users, tight control over deployments, enforcing standards | Custom syntax to learn, underlying code complexity, potential bottleneck for reviews/approvals |
| **Standardized deployments** | Simplicity for users, enforcing standards | Custom syntax to learn, underlying code complexity |

## Overview

The project uses a layered architecture with two modules:

1. **Account-level module** - Manages metastore and workspace assignments (requires account-level permissions)
2. **Metastore-level module** - Manages catalogs, credentials, and external locations (requires workspace-level permissions)

## Features

- **YAML-driven configuration** - Define all Unity Catalog resources in a single YAML file
- **Multi-cloud support** - Works with Azure (managed identity) and AWS (IAM roles)
- **Metastore management** - Create new metastores or reference existing ones
- **Workspace assignments** - Assign metastore to multiple workspaces
- **Storage credentials** - Configure credentials for accessing cloud storage
- **Service credentials** - Configure credentials for external services (e.g., model serving)
- **External locations** - Define external storage locations with associated credentials
- **Catalogs** - Create catalogs with storage roots and workspace bindings
- **Grants management** - Define permissions for all resources
- **Workspace bindings** - Control resource visibility across workspaces with read/write modes

## Prerequisites

- Terraform >= 1.0
- Databricks provider >= 1.80.0
- Databricks account with Unity Catalog enabled
- Appropriate permissions:
  - Account Admin for metastore operations
  - Metastore Admin for catalog and credential operations

## Usage

### 1. Create a configuration file

Create a YAML configuration file (e.g., `metastore-westeurope.yaml`) defining your Unity Catalog resources:

```yaml
config:
  uc_admin_workspace: "https://adb-xxxx.x.azuredatabricks.net"

metastore:
  # create: true  # Set to true to create a new metastore
  location: westeurope
  name: "my-metastore"
  owner: "Metastore Admins"
  workspaces:
    - 1234567890123456

storage_credentials:
  - name: "my-storage-credential"
    owner: "Metastore Admins"
    azure_managed_identity:
      access_connector_id: "/subscriptions/.../accessConnectors/my-connector"
    grants:
      - principal: "Data Engineers"
        privileges:
          - CREATE_EXTERNAL_LOCATION

external_locations:
  - name: "my-external-location"
    credential_name: "my-storage-credential"
    url: "abfss://container@storage.dfs.core.windows.net/"
    grants:
      - principal: "Data Engineers"
        privileges:
          - CREATE_EXTERNAL_TABLE

catalogs:
  - name: my_catalog
    owner: "Data Admins"
    storage_root: "abfss://container@storage.dfs.core.windows.net/"
    grants:
      - principal: "account users"
        privileges:
          - BROWSE
          - USE_CATALOG
```

### 2. Configure Terraform variables

Create a `terraform.tfvars` file:

```hcl
databricks_account_id = "your-account-id"
config_file           = "metastore-westeurope.yaml"
```

### 3. Deploy

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply changes
terraform apply
```

## Configuration Reference

### Top-level structure

| Key | Description |
|-----|-------------|
| `config.uc_admin_workspace` | URL of the workspace used for Unity Catalog administration |
| `metastore` | Metastore configuration |
| `storage_credentials` | List of storage credentials |
| `credentials` | List of service credentials |
| `external_locations` | List of external locations |
| `catalogs` | List of catalogs |

### Metastore configuration

| Key | Description |
|-----|-------------|
| `name` | Metastore name (defaults to location if not specified) |
| `location` | Cloud region for the metastore |
| `create` | Set to `true` to create a new metastore, `false` to use existing (default: `false`) |
| `owner` | Owner of the metastore |
| `workspaces` | List of workspace IDs to assign to this metastore |

### Resource configuration (storage_credentials, credentials, external_locations, catalogs)

All resources support:

| Key | Description |
|-----|-------------|
| `name` | Resource name (required) |
| `owner` | Owner of the resource |
| `grants` | List of grants with `principal` and `privileges` |
| `workspaces` | List of workspace bindings with `id` and optional `read_only` flag |

## Module Structure

```
.
├── main.tf                     # Module orchestration
├── config.tf                   # Configuration loading
├── providers.tf                # Provider configuration
├── variables.tf                # Input variables
├── terraform.tfvars            # Variable values
├── metastore-westeurope.yaml   # Example configuration
└── modules/
    ├── account-level/          # Account-level resources
    │   ├── metastore.tf
    │   ├── outputs.tf
    │   ├── providers.tf
    │   └── variables.tf
    └── metastore-level/        # Metastore-level resources
        ├── catalogs.tf
        ├── credentials.tf
        ├── ext_locations.tf
        ├── storage_credentials.tf
        ├── providers.tf
        └── variables.tf
```

## Authentication

The project uses two provider aliases:
- `databricks.account` - For account-level operations (metastore management)
- `databricks.workspace` - For workspace-level operations (catalogs, credentials, etc.)

Configure authentication using one of the supported methods:
- Azure CLI (`az login`)
- Service Principal
- Environment variables

See the [Databricks Terraform Provider documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication) for more details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.80.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_level"></a> [account\_level](#module\_account\_level) | ./modules/account-level | n/a |
| <a name="module_metastore_level"></a> [metastore\_level](#module\_metastore\_level) | ./modules/metastore-level | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_file"></a> [config\_file](#input\_config\_file) | The path to the config file | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks account ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

