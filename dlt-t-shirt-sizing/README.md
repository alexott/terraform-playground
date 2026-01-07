# DLT T-Shirt Sizing

This Terraform project provides a standardized approach to deploying [Databricks Delta Live Tables (DLT)](https://docs.databricks.com/delta-live-tables/) pipelines with predefined cluster configurations using a "T-shirt sizing" model.

## Overview

The T-shirt sizing approach simplifies DLT pipeline deployment by abstracting away complex cluster configuration into intuitive size categories (XS, S, M) with support for both fixed-size and autoscaling modes.

## Architecture

The project consists of:

- **Root module** — Deploys notebooks and orchestrates DLT pipeline creation
- **`dlt-module/`** — Reusable module for creating DLT pipelines with T-shirt size configurations

## T-Shirt Sizes

| Size | Mode | Node Type | Workers |
|------|------|-----------|---------|
| `xs_fixed` | Fixed | Smallest available | 1 |
| `xs_autoscaling` | Autoscaling | Smallest available | 1-2 |
| `s_fixed` | Fixed | 8+ cores, local disk | 2 |
| `s_autoscaling` | Autoscaling | 8+ cores, local disk | 1-3 |
| `m_fixed` | Fixed | 8+ cores, 32GB+ RAM, local disk | 4 |
| `m_autoscaling` | Autoscaling | 8+ cores, 32GB+ RAM, local disk | 1-4 |

## Prerequisites

- Terraform >= 1.0
- Databricks workspace with appropriate permissions
- [Databricks Terraform Provider](https://registry.terraform.io/providers/databricks/databricks/latest) >= 1.0

## Usage

```hcl
module "dlt_pipeline" {
  source       = "./dlt-module/"
  name         = "My DLT Pipeline"
  storage_path = "/tmp/dlt_storage"
  notebooks    = [databricks_notebook.my_notebook.id]
  development  = true
  t_shirt_size = "s_autoscaling"
}
```

## Project Structure

```
.
├── main.tf           # Provider configuration
├── notebooks.tf      # Notebook resources
├── pipeline.tf       # DLT pipeline module instantiations
├── notebooks/
│   └── DLT.py        # Sample DLT notebook
└── dlt-module/       # Reusable DLT pipeline module
    ├── dlt.tf        # Pipeline resource definition
    ├── nodes.tf      # T-shirt size definitions
    ├── provider.tf   # Module provider requirements
    └── variables.tf  # Module input variables
```

## Authentication

Configure authentication using any method supported by the Databricks Terraform provider:

- Environment variables (`DATABRICKS_HOST`, `DATABRICKS_TOKEN`)
- Databricks CLI profile
- Azure/AWS/GCP identity-based authentication

See the [Databricks provider documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication) for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dlt_m_autoscaling"></a> [dlt\_m\_autoscaling](#module\_dlt\_m\_autoscaling) | ./dlt-module/ | n/a |
| <a name="module_dlt_xs"></a> [dlt\_xs](#module\_dlt\_xs) | ./dlt-module/ | n/a |

## Resources

| Name | Type |
|------|------|
| [databricks_directory.dlt](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/directory) | resource |
| [databricks_notebook.dlt_python](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_current_user.me](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/current_user) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
