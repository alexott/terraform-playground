resource "azurerm_data_factory" "this" {
  name                = var.adf_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  identity {
    type = "SystemAssigned"
  }
}

# output "mi_obj_id" {
#   value = azurerm_data_factory.this.identity[0].principal_id
# }

output "mi_client_id" {
  value = data.azuread_service_principal.adf.application_id
}

data "azuread_service_principal" "adf" {
  object_id = azurerm_data_factory.this.identity[0].principal_id
}


resource "azurerm_data_factory_linked_service_azure_databricks" "msi_linked" {
  name            = "ADBLinkedServiceViaMSI"
  data_factory_id = azurerm_data_factory.this.id
  description     = "ADB Linked Service via MSI"
  adb_domain      = local.workspace_url

  msi_work_space_resource_id = data.azurerm_databricks_workspace.this.id

  # new_cluster_config {
  #   node_type             = data.databricks_node_type.smallest.id
  #   cluster_version       = data.databricks_spark_version.latest_lts
  #   min_number_of_workers = 1
  #   max_number_of_workers = 5
  # }

  instance_pool {
    instance_pool_id      = databricks_instance_pool.adf.id
    cluster_version       = data.databricks_spark_version.latest_lts.id
    min_number_of_workers = 1
    max_number_of_workers = 3
  }
}


resource "azurerm_data_factory_linked_service_azure_databricks" "pat_linked" {
  name            = "ADBLinkedServiceViaAccessToken"
  data_factory_id = azurerm_data_factory.this.id
  description     = "ADB Linked Service via Personal Access Token"
  access_token    = databricks_token.pat.token_value
  adb_domain      = local.workspace_url

  instance_pool {
    instance_pool_id      = databricks_instance_pool.adf.id
    cluster_version       = data.databricks_spark_version.latest_lts.id
    min_number_of_workers = 1
    max_number_of_workers = 3
  }
}

# for accessing PAT in AKV
resource "azurerm_data_factory_linked_service_key_vault" "this" {
  depends_on      = [azurerm_key_vault_access_policy.adf]
  name            = var.akv_name
  data_factory_id = azurerm_data_factory.this.id
  key_vault_id    = data.azurerm_key_vault.this.id
}

resource "azurerm_data_factory_linked_service_azure_databricks" "akv_pat_linked" {
  name            = "ADBLinkedServiceViaAccessTokenInAKV"
  data_factory_id = azurerm_data_factory.this.id
  description     = "ADB Linked Service via Personal Access Token in Azure Key Vaault"
  adb_domain      = local.workspace_url

  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.this.name
    secret_name         = azurerm_key_vault_secret.pat.name
  }

  instance_pool {
    instance_pool_id      = databricks_instance_pool.adf.id
    cluster_version       = data.databricks_spark_version.latest_lts.id
    min_number_of_workers = 1
    max_number_of_workers = 3
  }
}


resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = "Databricks activities"
  data_factory_id = azurerm_data_factory.this.id
  activities_json = <<JSON
[
    {
        "name": "Notebook_MSI",
        "type": "DatabricksNotebook",
        "typeProperties": {
            "notebookPath": "${databricks_notebook.adf_notebook.path}"
        },
        "linkedServiceName": {
            "referenceName": "${azurerm_data_factory_linked_service_azure_databricks.msi_linked.name}",
            "type": "LinkedServiceReference"
        }
    },
    {
        "name": "Notebook_PAT",
        "type": "DatabricksNotebook",
        "dependsOn": [
            {
                "activity": "Notebook_MSI",
                "dependencyConditions": [
                    "Skipped"
                ]
            }
        ],
        "typeProperties": {
            "notebookPath": "${databricks_notebook.adf_notebook.path}"
        },
        "linkedServiceName": {
            "referenceName": "${azurerm_data_factory_linked_service_azure_databricks.pat_linked.name}",
            "type": "LinkedServiceReference"
        }
    },
    {
        "name": "Notebook_PAT_in_AKV",
        "type": "DatabricksNotebook",
        "dependsOn": [
            {
                "activity": "Notebook_PAT",
                "dependencyConditions": [
                    "Skipped"
                ]
            }
        ],
        "typeProperties": {
            "notebookPath": "${databricks_notebook.adf_notebook.path}"
        },
        "linkedServiceName": {
            "referenceName": "${azurerm_data_factory_linked_service_azure_databricks.akv_pat_linked.name}",
            "type": "LinkedServiceReference"
        }
    }

]
  JSON
}
