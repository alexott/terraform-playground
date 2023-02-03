data "databricks_node_type" "xs" {
}

data "databricks_node_type" "s" {
  min_cores  = 8
  local_disk = true
}

data "databricks_node_type" "m" {
  min_cores     = 8
  local_disk    = true
  min_memory_gb = 32
}

locals {
  t_shirt_sizes = {
    xs_fixed = {
      node_type   = data.databricks_node_type.xs.id
      num_workers = 1
    }
    xs_autoscaling = {
      node_type   = data.databricks_node_type.xs.id
      min_workers = 1
      max_workers = 2
    }
    s_fixed = {
      node_type   = data.databricks_node_type.s.id
      num_workers = 2
    }
    s_autoscaling = {
      node_type   = data.databricks_node_type.s.id
      min_workers = 1
      max_workers = 3
    }
    m_fixed = {
      node_type   = data.databricks_node_type.m.id
      num_workers = 4
    }
    m_autoscaling = {
      node_type   = data.databricks_node_type.m.id
      min_workers = 1
      max_workers = 4
    }
  }
}
