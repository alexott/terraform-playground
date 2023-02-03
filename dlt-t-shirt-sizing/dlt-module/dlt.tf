locals {
  node_def = local.t_shirt_sizes[var.t_shirt_size]
}

resource "databricks_pipeline" "dlt" {
  storage = var.storage_path
  name    = var.name
  dynamic "library" {
    for_each = var.notebooks
    content {
      notebook {
        path = library.value
      }
    }
  }
  # Requires provider version > 1.9.1
  # dynamic "library" {
  #   for_each = var.files
  #   content {
  #     file {
  #       path = library.value
  #     }
  #   }
  # }
  development = var.development
  cluster {
    label        = "default"
    node_type_id = local.node_def.node_type
    num_workers  = (try(local.node_def.num_workers, 0) != 0) ? local.node_def.num_workers : null
    dynamic "autoscale" {
      for_each = (try(local.node_def.num_workers, 0) == 0) ? tomap({ a = 42 }) : tomap({})
      content {
        min_workers = try(local.node_def.min_workers, 1)
        max_workers = local.node_def.max_workers
        mode        = "enhanced"
      }
    }
  }
}
