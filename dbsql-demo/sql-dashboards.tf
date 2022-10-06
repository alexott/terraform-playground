resource "databricks_sql_visualization" "bar_vis" {
  type     = "chart"
  query_id = databricks_sql_query.demo_query.id
  options  = "{\"version\": 2, \"globalSeriesType\": \"column\", \"sortX\": true, \"sortY\": true, \"legend\": {\"traceorder\": \"normal\"}, \"xAxis\": {\"type\": \"-\", \"labels\": {\"enabled\": true}}, \"yAxis\": [{\"type\": \"-\"}, {\"type\": \"-\", \"opposite\": true}], \"alignYAxesAtZero\": false, \"error_y\": {\"type\": \"data\", \"visible\": true}, \"series\": {\"stacking\": \"stack\", \"error_y\": {\"type\": \"data\", \"visible\": true}}, \"seriesOptions\": {\"column_54bb30994004\": {\"name\": \"count(1)\", \"yAxis\": 0}}, \"valuesOptions\": {}, \"direction\": {\"type\": \"counterclockwise\"}, \"sizemode\": \"diameter\", \"coefficient\": 1, \"numberFormat\": \"0,0[.]00000\", \"percentFormat\": \"0[.]00%\", \"textFormat\": \"\", \"missingValuesAsZero\": true, \"useAggregationsUi\": true, \"swappedAxes\": false, \"dateTimeFormat\": \"DD/MM/YY HH:mm\", \"showDataLabels\": false, \"columnConfigurationMap\": {\"x\": {\"column\": \"country\", \"id\": \"column_54bb30994002\"}, \"series\": {\"column\": \"first(country_code)\", \"id\": \"column_54bb30994003\"}, \"y\": [{\"column\": \"count(1)\", \"transform\": \"SUM\", \"id\": \"column_54bb30994004\"}]}, \"isAggregationOn\": true}"
  name     = "Bar 1"
}

resource "databricks_sql_widget" "bar_widget" {
  visualization_id = databricks_sql_visualization.bar_vis.visualization_id
  title            = "Bar - Demo visualizations"
  position {
    size_y = 8
    size_x = 3
    pos_y  = 8
  }
  dashboard_id = databricks_sql_dashboard.demo_dashboard.id
}

resource "databricks_sql_widget" "map_widget" {
  visualization_id = databricks_sql_visualization.map_vis.visualization_id
  title            = "Map (Choropleth) - Demo visualizations"
  position {
    size_y = 8
    size_x = 6
  }
  dashboard_id = databricks_sql_dashboard.demo_dashboard.id
}

resource "databricks_sql_widget" "f2c52db4_e05a_4658_8fd1_913a462d684d8e7e941f_9c1d_465e_b17e_4f0d1dab7720" {
  visualization_id = databricks_sql_visualization.table_vis.visualization_id
  title            = "Table - Demo visualizations"
  position {
    size_y = 14
    size_x = 3
    pos_y  = 8
    pos_x  = 3
  }
  dashboard_id = databricks_sql_dashboard.demo_dashboard.id
}

resource "databricks_sql_visualization" "map_vis" {
  type     = "choropleth"
  query_id = databricks_sql_query.demo_query.id
  options  = "{\"mapType\": \"countries\", \"keyColumn\": \"first(country_code)\", \"targetField\": \"iso_a2\", \"valueColumn\": \"count(1)\", \"clusteringMode\": \"e\", \"steps\": 5, \"valueFormat\": \"0,0.00\", \"noValuePlaceholder\": \"N/A\", \"colors\": {\"min\": \"#799CFF\", \"max\": \"#002FB4\", \"background\": \"#ffffff\", \"borders\": \"#ffffff\", \"noValue\": \"#dddddd\"}, \"legend\": {\"visible\": true, \"position\": \"bottom-left\", \"alignText\": \"right\"}, \"tooltip\": {\"enabled\": true, \"template\": \"<b>{{ @@name }}</b>: {{ @@value }}\"}, \"popup\": {\"enabled\": true, \"template\": \"Region: <b>{{ @@name }}</b>\\n<br>\\nValue: <b>{{ @@value }}</b>\"}}"
  name     = "Map (Choropleth) 2"
}

resource "databricks_sql_visualization" "table_vis" {
  type     = "table"
  query_id = databricks_sql_query.demo_query.id
  options  = "{\"version\": 2}"
  name     = "Table"
}

resource "databricks_sql_dashboard" "demo_dashboard" {
  name = "Demo Visualizations"
}
