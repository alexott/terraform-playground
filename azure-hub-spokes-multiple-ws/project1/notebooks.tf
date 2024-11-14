resource "databricks_notebook" "dlt_demo" {
  content_base64 = base64encode(<<-EOT
# Databricks notebook source
import dlt

@dlt.view
def input():
  return spark.range(10)

@dlt.table
def python():
  return dlt.read("input")
    EOT
  )
  path     = "/Project1/Pipeline"
  language = "PYTHON"
}