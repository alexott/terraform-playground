# Databricks notebook source
import dlt

# COMMAND ----------

@dlt.view
def input():
  return spark.range(10)

# COMMAND ----------

@dlt.table
def python():
  return dlt.read("input")

# COMMAND ----------

