terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  # Configuration options
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

resource "databricks_cluster" "git_proxy" {
  cluster_name            = "Git Proxy"
  spark_version           = "12.2.x-scala2.12"
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 0

  spark_conf = {
    # Single-node
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  spark_env_vars = var.spark_envs

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}

resource "databricks_workspace_conf" "git_proxy" {
  custom_config = {
    "enableGitProxy" : true,
    "gitProxyClusterId" : databricks_cluster.git_proxy.id
  }
}
