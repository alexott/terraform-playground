terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
  # Configuration options
}

# FILL THIS!
locals {
  azure_tenant_id                  = ""
  azure_client_id                  = ""
  azure_client_secret_secret_scope = ""
  azure_client_secret_secret_key   = ""
  abfss_init_script_path           = "abfss://<container>@<storage_account>.dfs.core.windows.net/init_script.sh"
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Test ABFSS init script"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 10
  }

  spark_conf = {
    "spark.hadoop.fs.azure.account.auth.type" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint" : "https://login.microsoftonline.com/${local.azure_tenant_id}/oauth2/token",
    "spark.hadoop.fs.azure.account.oauth2.client.id" : local.azure_client_id,
    "spark.hadoop.fs.azure.account.oauth2.client.secret" : "{{secrets/${local.azure_client_secret_secret_scope}/${local.azure_client_secret_secret_key}}}"
  }

  init_scripts {
    abfss {
      destination = local.abfss_init_script_path
    }
  }
}
