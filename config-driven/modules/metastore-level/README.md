# Metastore-Level Module

This module manages Databricks Unity Catalog resources at the metastore/workspace level, including catalogs, credentials, and external locations.

## Description

The metastore-level module handles:

- **Storage Credentials** - Credentials for accessing cloud storage (Azure Managed Identity, AWS IAM Role)
- **Service Credentials** - Credentials for external services like model serving endpoints
- **External Locations** - Cloud storage locations accessible via Unity Catalog
- **Catalogs** - Unity Catalog catalogs with optional storage roots
- **Grants** - Permission management for all resource types
- **Workspace Bindings** - Control resource visibility across workspaces

## Usage

This module is called from the root module and requires workspace-level Databricks provider:

```hcl
module "metastore_level" {
  source     = "./modules/metastore-level"
  config     = local.config
  depends_on = [module.account_level]
  providers = {
    databricks = databricks.workspace
  }
}
```

## Configuration

The module expects a configuration object with the following sections:

### Storage Credentials

Credentials used for accessing cloud storage (used by external locations):

```yaml
storage_credentials:
  - name: "my-storage-credential"
    owner: "Metastore Admins"
    azure_managed_identity:
      access_connector_id: "/subscriptions/.../accessConnectors/my-connector"
      managed_identity_id: "..."  # Optional
    # OR for AWS:
    # aws_iam_role:
    #   role_arn: "arn:aws:iam::123456789:role/my-role"
    grants:
      - principal: "Data Engineers"
        privileges:
          - CREATE_EXTERNAL_LOCATION
    workspaces:  # Optional - restrict to specific workspaces
      - id: 1234567890123456
        read_only: false
```

### Service Credentials

Credentials for external services (e.g., model serving, GenAI):

```yaml
credentials:
  - name: "my-service-credential"
    owner: "ML Engineers"
    purpose: "SERVICE"  # Optional, defaults to "SERVICE"
    azure_managed_identity:
      access_connector_id: "/subscriptions/.../accessConnectors/my-connector"
    grants:
      - principal: "ML Team"
        privileges:
          - ALL_PRIVILEGES
```

### External Locations

Cloud storage locations accessible through Unity Catalog:

```yaml
external_locations:
  - name: "my-external-location"
    credential_name: "my-storage-credential"  # Reference to storage credential
    url: "abfss://container@storage.dfs.core.windows.net/path/"
    owner: "Data Admins"
    comment: "Production data lake"
    force_destroy: false
    grants:
      - principal: "Data Engineers"
        privileges:
          - CREATE_EXTERNAL_TABLE
          - CREATE_EXTERNAL_VOLUME
          - CREATE_MANAGED_STORAGE
    workspaces:
      - id: 1234567890123456
        read_only: true
```

### Catalogs

Unity Catalog catalogs:

```yaml
catalogs:
  - name: my_catalog
    owner: "Data Admins"
    comment: "Production catalog"
    storage_root: "abfss://container@storage.dfs.core.windows.net/"
    force_destroy: false
    properties:
      environment: "production"
    grants:
      - principal: "account users"
        privileges:
          - BROWSE
          - USE_CATALOG
    workspaces:  # Optional - makes catalog ISOLATED mode
      - id: 1234567890123456
        read_only: false
      - id: 9876543210987654
        read_only: true
```

## Resource Dependencies

The module manages dependencies automatically:

```
Storage Credentials
        ↓
External Locations
        ↓
    Catalogs
```

## Workspace Bindings

All resources support workspace bindings to control visibility:

- **No workspaces specified** - Resource is available to all workspaces (OPEN mode for catalogs)
- **Workspaces specified** - Resource is restricted to listed workspaces (ISOLATED mode for catalogs)
- **read_only: true** - Workspace has read-only access to the resource
- **read_only: false** (default) - Workspace has read-write access

## Resources

| Name | Type | Description |
|------|------|-------------|
| `databricks_storage_credential.this` | resource | Storage credentials |
| `databricks_credential.this` | resource | Service credentials |
| `databricks_external_location.this` | resource | External locations |
| `databricks_catalog.this` | resource | Catalogs |
| `databricks_grants.*` | resource | Grants for all resource types |
| `databricks_workspace_binding.*` | resource | Workspace bindings for all resource types |

## Requirements

- Metastore admin or appropriate Unity Catalog permissions
- Workspace-level Databricks provider
- Account-level module must run first (for metastore assignment)

## Multi-Cloud Support

The module supports both Azure and AWS:

**Azure:**
```yaml
azure_managed_identity:
  access_connector_id: "/subscriptions/.../accessConnectors/..."
  managed_identity_id: "..."  # Optional user-assigned identity
```

**AWS:**
```yaml
aws_iam_role:
  role_arn: "arn:aws:iam::123456789:role/my-role"
```

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
| [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_credential.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/credential) | resource |
| [databricks_external_location.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) | resource |
| [databricks_grants.catalogs](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.external_locations](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.service_credentials](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.storage_credentials](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_storage_credential.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential) | resource |
| [databricks_workspace_binding.catalogs](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) | resource |
| [databricks_workspace_binding.ext_locations](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) | resource |
| [databricks_workspace_binding.service_credentials](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) | resource |
| [databricks_workspace_binding.storage_credentials](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | The config | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

