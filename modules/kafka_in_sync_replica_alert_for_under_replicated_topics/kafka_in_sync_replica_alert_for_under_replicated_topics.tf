resource "shoreline_notebook" "kafka_in_sync_replica_alert_for_under_replicated_topics" {
  name       = "kafka_in_sync_replica_alert_for_under_replicated_topics"
  data       = file("${path.module}/data/kafka_in_sync_replica_alert_for_under_replicated_topics.json")
  depends_on = [shoreline_action.invoke_monitor_replication_factor,shoreline_action.invoke_change_replication_factor]
}

resource "shoreline_file" "monitor_replication_factor" {
  name             = "monitor_replication_factor"
  input_file       = "${path.module}/data/monitor_replication_factor.sh"
  md5              = filemd5("${path.module}/data/monitor_replication_factor.sh")
  description      = "The replication factor for the affected topics may have been set too low, increasing the likelihood of under-replication."
  destination_path = "/agent/scripts/monitor_replication_factor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "change_replication_factor" {
  name             = "change_replication_factor"
  input_file       = "${path.module}/data/change_replication_factor.sh"
  md5              = filemd5("${path.module}/data/change_replication_factor.sh")
  description      = "Increase the replication factor for the affected topic to ensure that there are more replicas of the partitions available."
  destination_path = "/agent/scripts/change_replication_factor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_monitor_replication_factor" {
  name        = "invoke_monitor_replication_factor"
  description = "The replication factor for the affected topics may have been set too low, increasing the likelihood of under-replication."
  command     = "`chmod +x /agent/scripts/monitor_replication_factor.sh && /agent/scripts/monitor_replication_factor.sh`"
  params      = ["BROKER_HOST_PORT","TOPIC_NAME"]
  file_deps   = ["monitor_replication_factor"]
  enabled     = true
  depends_on  = [shoreline_file.monitor_replication_factor]
}

resource "shoreline_action" "invoke_change_replication_factor" {
  name        = "invoke_change_replication_factor"
  description = "Increase the replication factor for the affected topic to ensure that there are more replicas of the partitions available."
  command     = "`chmod +x /agent/scripts/change_replication_factor.sh && /agent/scripts/change_replication_factor.sh`"
  params      = ["NEW_PARTITION_COUNT","NEW_REPLICATION_FACTOR","TOPIC_NAME","KAFKA_HOME_DIRECTORY"]
  file_deps   = ["change_replication_factor"]
  enabled     = true
  depends_on  = [shoreline_file.change_replication_factor]
}

