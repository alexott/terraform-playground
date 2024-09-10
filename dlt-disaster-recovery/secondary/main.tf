
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
}

data "databricks_current_user" "me" {
}

module "dlt_pipeline" {
  source           = "../module"
  active_region    = false
  pipeline_name    = "ingest_pipeline"
  pipeline_storage = "/tmp/dlt-dr"
  #  pipeline_storage    = "s3://<secondary region>/bronze_layer"
  notebooks           = ["notebook1.py", "notebook2.py"]
  notebooks_directory = "${data.databricks_current_user.me.home}/DLT_DR_TF"
}
