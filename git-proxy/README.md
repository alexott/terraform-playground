# Setting up Databricks Git Proxy cluster

Databricks now allows to connect to the private Git servers using a dedicated cluster that runs a special script.  The setup process is described in the [documentation](https://learn.microsoft.com/en-us/azure/databricks/repos/git-proxy), and involves [execution of a notebook](https://github.com/databricks/databricks-repos-proxy/blob/main/enable_git_proxy_jupyter.ipynb) to configure everything.

This folder contains alternative approach to configuration by using Terraform - this is simpler, especially if you want to automatically deploy everything as part of the workspace deployment.  We just need to create smallest cluster without auto-termination, and configure two workspace options.

Just [configure authentication](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication), and do standard series: `terraform init`, `terraform plan`, `terraform apply`.
