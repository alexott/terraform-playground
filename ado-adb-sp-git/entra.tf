data "azuread_application" "this" {
  client_id = var.entra_client_id
}

locals {
  host_without_schema = replace(var.databricks_host, "https://", "")
}

resource "azuread_application_federated_identity_credential" "this" {
  application_id = data.azuread_application.this.id
  display_name   = replace("${local.host_without_schema} federation", "/\\W/", "_")
  description    = "Git federation for ${var.databricks_host}"
  issuer         = "${var.databricks_host}/oidc"
  subject        = data.azuread_application.this.client_id
  audiences      = ["api://AzureADTokenExchange"]
}
