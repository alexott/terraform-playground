This folder contains an example of Terraform deployment for DLT Pipeline with Disaster Recovery (DR) used in the blog post [Production-Ready and Resilient Disaster Recovery for DLT Pipelines](https://www.databricks.com/blog/2023/03/17/production-ready-and-resilient-disaster-recovery-dlt-pipelines.html).

## DR implementation approach

The DR for DLT pipeline is implemented as following (prerequisite is that input data is available in both regions, so results would be the same):

* In normal mode:
  * In primary region, DLT pipeline runs in the continuous mode (controlled by setting `active_region` to `true`)
  * In secondary region, DLT pipeline is configured to work in triggered mode (controlled by setting `active_region` to `false`), and triggered regularly by a Databricks job (for example, at night) to process all available data to avoid handling of big backlog in case of failover.
* In case of failure:
  * DLT pipeline in secondary region is reconfigured to run in continuous mode (controlled by setting `active_region` to `true`) - this will automatically start the DLT pipeline.
  * DLT pipeline in primary region could be stopped (if service is available)
* When operations are restored:
  * DLT pipeline in primary region is started to process a backlog
  * DLT pipeline in the secondary region is reconfigured back to work in triggered mode (by setting `active_region` to `false`).  When this happens, DLT pipeline is stopped automatically.

## Terraform implementation

This implementation consists of 3 folders:

* `module` - contains actual code of notebooks (we can switch to repos if necessary), DLT pipeline, and Databricks job that is used to trigger DLT pipeline in the secondary region.
* `primary` - contains code to configure a module according to settings for primary region - workspace, storage location, `active_region` flag
* `secondary` - same, but for secondary region

The Terraform module receives a number of variables to configure DLT pipeline:

* `active_region` - boolean flag is used to specify if DLT pipeline should run in the continuous mode or not.  It also used to configure the Databricks job (when this flag is set to `true`, the job is paused, and when it's set to `false`, then job is executed regularly).
* `pipeline_name` - name of the DLT pipeline (it also will be used to form a name of Databricks job).
* `pipeline_storage` - path to cloud storage for the DLT pipeline.
* `pipeline_target` - name of the target database for DLT pipeline.
* `pipeline_edition` - DLT pipeline edition (default `CORE`).
* `notebooks` - list of notebooks to use in the DLT pipeline.  Currently notebooks are stored in the module's subdirectory, but this logic could be changed.
* `notebooks_directory` - base path for notebooks in the workspace
