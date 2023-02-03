-- Databricks notebook source
CREATE OR REFRESH LIVE TABLE sql 
AS SELECT * from LIVE.input
