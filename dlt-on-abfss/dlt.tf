resource "databricks_pipeline" "test_abfss" {
  storage = var.abfss_path
  name    = "Test ABFSS (${data.databricks_current_user.me.alphanumeric})"
  library {
    notebook {
      path = databricks_notebook.dlt_test_abfss_sql.id
    }
  }
  library {
    notebook {
      path = databricks_notebook.dlt_test_abfss_python.id
    }
  }
  development = true
  cluster {
    spark_conf = {
      "fs.azure.account.auth.type"              = "OAuth"
      "fs.azure.account.oauth.provider.type"    = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
      "fs.azure.account.oauth2.client.endpoint" = "https://login.microsoftonline.com/${var.tenant_id}/oauth2/token"
      "fs.azure.account.oauth2.client.id"       = var.client_id
      "fs.azure.account.oauth2.client.secret"   = "{{secrets/${var.sp_secret_scope_name}/${var.sp_secret_secret_name}}}"
    }
    label = "default"
  }
}
