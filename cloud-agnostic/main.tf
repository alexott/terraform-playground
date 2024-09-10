terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
  # Configuration options
}

data "databricks_current_user" "me" {}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  ml                = true
}

data "databricks_node_type" "this" {
  local_disk = true
  min_cores  = 8
  category   = "Compute Optimized"
}

resource "databricks_notebook" "this" {
  path     = "${data.databricks_current_user.me.home}/Terraform Tests/Test"
  language = "PYTHON"
  content_base64 = base64encode(<<-EOT
    # created from ${abspath(path.module)}
    display(spark.range(10))
    EOT
  )
}

resource "databricks_job" "this" {
  name = "Terraform Demo (${data.databricks_current_user.me.alphanumeric})"

  new_cluster {
    num_workers   = 1
    spark_version = data.databricks_spark_version.latest_lts.id
    node_type_id  = data.databricks_node_type.this.id
  }

  notebook_task {
    notebook_path = databricks_notebook.this.path
  }
}

