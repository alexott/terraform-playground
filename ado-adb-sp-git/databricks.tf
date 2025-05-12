resource "databricks_repo" "this" {
  url = var.ado_repo_url

  depends_on = [
    databricks_git_credential.ado
  ]
}

resource "databricks_git_credential" "ado" {
  git_provider = "azureDevOpsServicesAad"
  force        = true

  depends_on = [
    azuread_application_federated_identity_credential.this
  ]
}
