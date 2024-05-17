# Azure Databricks workspace with Customer Managed Keys enabled from Azure Key Vault with RBAC enabled

This module creates Azure Databricks workspace with [Customer Managed
Keys](https://learn.microsoft.com/en-us/azure/databricks/security/keys/customer-managed-keys)
enabled for managed services, managed disks and DBFS.  Encryption keys are obtained from
Azure Key Vault that uses role-based access control (RBAC) instead of access policies
described in Databricks documentation.
