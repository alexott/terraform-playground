# DLT Module

A Terraform module for deploying Databricks Delta Live Tables (DLT) pipelines with standardized "T-shirt sizing" cluster configurations.

## Overview

This module simplifies DLT pipeline deployment by providing predefined cluster configurations based on workload size. Instead of manually specifying node types, worker counts, and autoscaling parameters, users select from intuitive T-shirt sizes.

## Features

- **T-shirt sizing** — Predefined cluster configurations (XS, S, M) for common workload patterns
- **Fixed and autoscaling modes** — Each size supports both fixed worker count and autoscaling variants
- **Cloud-agnostic node selection** — Uses `databricks_node_type` data source to automatically select appropriate instance types
- **Enhanced autoscaling** — Leverages DLT's enhanced autoscaling mode for optimal performance

## Available T-Shirt Sizes

| Size | Mode | Description | Workers |
|------|------|-------------|---------|
| `xs_fixed` | Fixed | Minimal resources for development/testing | 1 |
| `xs_autoscaling` | Autoscaling | Minimal resources with scaling capability | 1-2 |
| `s_fixed` | Fixed | Small workloads with local disk | 2 |
| `s_autoscaling` | Autoscaling | Small workloads with scaling | 1-3 |
| `m_fixed` | Fixed | Medium workloads with more memory | 4 |
| `m_autoscaling` | Autoscaling | Medium workloads with scaling | 1-4 |

## Usage

### Basic Example

```hcl
module "my_dlt_pipeline" {
  source       = "./dlt-module/"
  name         = "My Analytics Pipeline"
  storage_path = "abfss://container@storage.dfs.core.windows.net/dlt"
  notebooks    = [databricks_notebook.etl.id]
  t_shirt_size = "s_autoscaling"
}
```

### Development Pipeline

```hcl
module "dev_pipeline" {
  source       = "./dlt-module/"
  name         = "Dev Pipeline"
  storage_path = "/tmp/dev_dlt"
  notebooks    = [databricks_notebook.dev.id]
  development  = true
  t_shirt_size = "xs_fixed"
}
```

### Production Pipeline with Multiple Notebooks

```hcl
module "prod_pipeline" {
  source       = "./dlt-module/"
  name         = "Production ETL Pipeline"
  storage_path = "abfss://prod@storage.dfs.core.windows.net/dlt"
  notebooks    = [
    databricks_notebook.bronze.id,
    databricks_notebook.silver.id,
    databricks_notebook.gold.id
  ]
  development  = false
  t_shirt_size = "m_autoscaling"
}
```

## Requirements

| Name | Version |
|------|---------|
| databricks | ~> 1.0 |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | ~> 1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_pipeline.dlt](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/pipeline) | resource |
| [databricks_node_type.m](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |
| [databricks_node_type.s](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |
| [databricks_node_type.xs](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the DLT pipeline | `string` | n/a | yes |
| <a name="input_storage_path"></a> [storage\_path](#input\_storage\_path) | Path to ADLS location to keep DLT data (abfss://...) | `string` | n/a | yes |
| <a name="input_continuous"></a> [continuous](#input\_continuous) | If the pipeline should run in continuos mode | `bool` | `false` | no |
| <a name="input_development"></a> [development](#input\_development) | If the pipeline is in development mode | `bool` | `false` | no |
| <a name="input_files"></a> [files](#input\_files) | List of notebook paths | `list(string)` | `[]` | no |
| <a name="input_notebooks"></a> [notebooks](#input\_notebooks) | List of notebook paths | `list(string)` | `[]` | no |
| <a name="input_t_shirt_size"></a> [t\_shirt\_size](#input\_t\_shirt\_size) | T-shirt cluster size (xs\_fixed, xs\_autoscaling, ...) | `string` | `"xs_fixed"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

