# terraform-playground

Different snippets of Terraform code. Primarily around Databricks:

* [aad-dbx-sync](aad-dbx-sync) allows to synchronize users/groups/service principals from Azure Active Directory into Databricks Workspace.
* [adb-workspace-cmk-rbac](adb-workspace-cmk-rbac) shows how to create Azure Databricks workspace with Customer Managed Keys encryption enabled that uses Azure Key Vault with RBAC enabled instead of Access policies.
* [adf-dbx-demo](adf-dbx-demo) shows how to configure different authentication methods for Azure Data Factory links to Azure Databricks.
* [akv-to-db-secrets](akv-to-db-secrets) shows how to replicate secrets from Azure Key Vault into the Databricks Secrets scope (for example, to access them in another cloud).
* [azure-hub-spokes-multiple-ws](azure-hub-spokes-multiple-ws) shows possible multi-module organization for deployment of Azure Databricks workspaces in hub-and-spoke architecture with separation of prod and dev workspaces, together with groups assignments to specific workspace, creation of shared resources, etc.
* [cloud-agnostic](cloud-agnostic) shows how to create cloud agnostic deployments of Databricks resources. See the [blog post](https://alexott.blogspot.com/2022/11/cloud-agnostic-resources-deployment.html) for more details about it.
* [cluster-init-script-on-abfss](cluster-init-script-on-abfss) shows how to configure cluster to use init script from the Azure Storage Account (using `abfss` protocol)
* [databricks-modules-demo1](databricks-modules-demo1) shows how to use Databricks modules to provision Azure Databricks workspace.
* [dbsql-demo](dbsql-demo) demonstrates how to use Terraform to create Databricks SQL resources - SQL Warehouse, queries and dashboards.
* [dlt-disaster-recovery](dlt-disaster-recovery) contains example of Terraform deployment for DLT Pipeline with Disaster Recovery (DR) used in the blog post [Production-Ready and Resilient Disaster Recovery for DLT Pipelines](https://www.databricks.com/blog/2023/03/17/production-ready-and-resilient-disaster-recovery-dlt-pipelines.html).
* [dlt-on-abfss](dlt-on-abfss) shows how to configure Delta Live Table (DLT) pipeline to store data in Azure Storage (ABFSS protocol).
* [dlt-t-shirt-sizing](dlt-t-shirt-sizing) shows how to create a reusable Terraform module for DLT pipeline that is configured by T-shirt size-style specification instead of using hardcoded min/max number of nodes.
* [git-credential-for-sp](git-credential-for-sp) shows how to set Git credential for Databricks Service Principal on AWS or GCP.
* [git-proxy](git-proxy) shows how to set up a Databricks Git Proxy cluster for connectivity to the private Git repositories.
* [jobs-demo](jobs-demo) demonstrate how to create a simple Databricks workflow with multiple tasks inside.
* [ncc-plus-storage](ncc-plus-storage) shows how to configure Azure Storage Firewall with subnets from Azure Databricks Network Connectivity Config to allow access to the data from Serverless services.
* [plan-changes](plan-changes) script that shows a summary of Terraform plan changes
