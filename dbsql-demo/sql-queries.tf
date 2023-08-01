resource "databricks_sql_query" "demo_query" {
  query          = <<-EOT
            select count(*) as cnt, country, first(country_code)
              from cybersecurity.alexey_ott_dns.silver_dns
              where country is not null
              group by country
              order by cnt desc
        EOT
  name           = "Demo query"
  data_source_id = databricks_sql_endpoint.demo.data_source_id
}
