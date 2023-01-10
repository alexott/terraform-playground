-- Databricks notebook source
CREATE OR REFRESH LIVE TABLE sql 
LOCATION 'abfss://test@aottlrs.dfs.core.windows.net/dlt/sql'
AS SELECT * from LIVE.input