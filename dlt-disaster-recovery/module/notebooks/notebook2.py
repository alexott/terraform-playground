# Databricks notebook source

import dlt

@dlt.table
def bronze():
    return dlt.read_stream("raw").selectExpr("*", "rand() as rnd")
