# Databricks notebook source

import dlt

@dlt.table
def my_table():
    return spark.range(10)
