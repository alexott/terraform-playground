# terraform-playground

Different snippets of Terraform code. Primarily around Databricks

* [dbsql-demo](dbsql-demo) demonstrates how to use Terraform to create Databricks SQL resources - SQL Warehouse, queries and dashboards.
* [aad-dbx-sync](aad-dbx-sync) allows to synchronize users/groups/service principals from Azure Active Directory into Databricks Workspace.
* [jobs-demo](jobs-demo) demonstrate how to create a simple Databricks workflow with multiple tasks inside.
* [cloud-agnostic](cloud-agnostic) shows how to create cloud agnostic deployments of Databricks resources. See the [blog post](https://alexott.blogspot.com/2022/11/cloud-agnostic-resources-deployment.html) for more details about it.
* [dlt-on-abfss](dlt-on-abfss) shows how to configure Delta Live Table (DLT) pipeline to store data in Azure Storage (ABFSS protocol).
* [dlt-t-shirt-sizing](dlt-t-shirt-sizing) shows how to create a reusable Terraform module for DLT pipeline that is configured by T-shirt size-style specification instead of using hardcoded min/max number of nodes.
* [akv-to-db-secrets](akv-to-db-secrets) shows how to replicate secrets from Azure Key Vault into the Databricks Secrets scope (for example, to access them in another cloud)
* [cluster-init-script-on-abfss](cluster-init-script-on-abfss) shows how to configure cluster to use init script from the Azure Storage Account (using `abfss` protocol)
