# Databricks notebook source

import dlt

@dlt.view
def raw():
    return spark.readStream.format("rate").load()
