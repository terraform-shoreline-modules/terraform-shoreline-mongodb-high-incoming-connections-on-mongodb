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

module "high_incoming_connections_on_mongodb" {
  source    = "./modules/high_incoming_connections_on_mongodb"

  providers = {
    shoreline = shoreline
  }
}