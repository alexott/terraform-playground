# Databricks notebook source
import dlt

# COMMAND ----------

@dlt.view
def input():
  return spark.range(10)

# COMMAND ----------

@dlt.table(
  path="abfss://test@aottlrs.dfs.core.windows.net/dlt/python"
)
def python():
  return dlt.read("input")

# COMMAND ----------

