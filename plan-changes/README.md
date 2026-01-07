## Showing the summary of Terraform plan changes

This directory contains script `summarize-tf-plan-changes.sh` that uses combination of `terraform plan` + `terraform show` + `jq` to generate a summary of Terraform plan changes, like this:

```json
{
  "create": [
    {
      "type": "databricks_mlflow_webhook",
      "address": "databricks_mlflow_webhook.url"
    }
  ],
  "delete": [
    {
      "type": "databricks_notebook",
      "address": "databricks_notebook.this2"
    }
  ],
  "update": [
    {
      "type": "databricks_job",
      "address": "databricks_job.this"
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->