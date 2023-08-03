resource "shoreline_notebook" "high_incoming_connections_on_mongodb" {
  name       = "high_incoming_connections_on_mongodb"
  data       = file("${path.module}/data/high_incoming_connections_on_mongodb.json")
  depends_on = [shoreline_action.invoke_log_file_check,shoreline_action.invoke_mongo_log_check,shoreline_action.invoke_incoming_connection_search,shoreline_action.invoke_set_max_connections]
}

resource "shoreline_file" "log_file_check" {
  name             = "log_file_check"
  input_file       = "${path.module}/data/log_file_check.sh"
  md5              = filemd5("${path.module}/data/log_file_check.sh")
  description      = "Check if the log file exists"
  destination_path = "/agent/scripts/log_file_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mongo_log_check" {
  name             = "mongo_log_check"
  input_file       = "${path.module}/data/mongo_log_check.sh"
  md5              = filemd5("${path.module}/data/mongo_log_check.sh")
  description      = "If no entries are found, exit with an error message"
  destination_path = "/agent/scripts/mongo_log_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "incoming_connection_search" {
  name             = "incoming_connection_search"
  input_file       = "${path.module}/data/incoming_connection_search.sh"
  md5              = filemd5("${path.module}/data/incoming_connection_search.sh")
  description      = "If entries are found, print them to the console"
  destination_path = "/agent/scripts/incoming_connection_search.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_max_connections" {
  name             = "set_max_connections"
  input_file       = "${path.module}/data/set_max_connections.sh"
  md5              = filemd5("${path.module}/data/set_max_connections.sh")
  description      = "Increase the maximum number of allowed connections to accommodate the current traffic or add additional resources to handle the incoming connections."
  destination_path = "/agent/scripts/set_max_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_log_file_check" {
  name        = "invoke_log_file_check"
  description = "Check if the log file exists"
  command     = "`chmod +x /agent/scripts/log_file_check.sh && /agent/scripts/log_file_check.sh`"
  params      = []
  file_deps   = ["log_file_check"]
  enabled     = true
  depends_on  = [shoreline_file.log_file_check]
}

resource "shoreline_action" "invoke_mongo_log_check" {
  name        = "invoke_mongo_log_check"
  description = "If no entries are found, exit with an error message"
  command     = "`chmod +x /agent/scripts/mongo_log_check.sh && /agent/scripts/mongo_log_check.sh`"
  params      = []
  file_deps   = ["mongo_log_check"]
  enabled     = true
  depends_on  = [shoreline_file.mongo_log_check]
}

resource "shoreline_action" "invoke_incoming_connection_search" {
  name        = "invoke_incoming_connection_search"
  description = "If entries are found, print them to the console"
  command     = "`chmod +x /agent/scripts/incoming_connection_search.sh && /agent/scripts/incoming_connection_search.sh`"
  params      = []
  file_deps   = ["incoming_connection_search"]
  enabled     = true
  depends_on  = [shoreline_file.incoming_connection_search]
}

resource "shoreline_action" "invoke_set_max_connections" {
  name        = "invoke_set_max_connections"
  description = "Increase the maximum number of allowed connections to accommodate the current traffic or add additional resources to handle the incoming connections."
  command     = "`chmod +x /agent/scripts/set_max_connections.sh && /agent/scripts/set_max_connections.sh`"
  params      = ["MAX_CONNECTIONS"]
  file_deps   = ["set_max_connections"]
  enabled     = true
  depends_on  = [shoreline_file.set_max_connections]
}

