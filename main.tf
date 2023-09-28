terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_in_sync_replica_alert_for_under_replicated_topics" {
  source    = "./modules/kafka_in_sync_replica_alert_for_under_replicated_topics"

  providers = {
    shoreline = shoreline
  }
}