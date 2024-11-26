
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "root"
}

# Ottieni la password di Elasticsearch da Vault
data "vault_generic_secret" "elastic_password" {
  path = "secret/elastic"
}

# Ottieni la password di Kibana da Vault
data "vault_generic_secret" "kibana_password" {
  path = "secret/kibana"
}

locals {
  # Variabili d'ambiente per Elasticsearch
  elastic_env = [
    "node.name=es01",
    "ELASTIC_PASSWORD=${data.vault_generic_secret.elastic_password.data["ELASTIC_PASSWORD"]}",
    "discovery.type=single-node",
    "xpack.security.enabled=true",
    "xpack.security.http.ssl.enabled=true",
    "xpack.security.http.ssl.key=/usr/share/elasticsearch/config/certs/es01/es01.key",
    "xpack.security.http.ssl.certificate=/usr/share/elasticsearch/config/certs/es01/es01.crt",
    "xpack.security.http.ssl.certificate_authorities=/usr/share/elasticsearch/config/certs/ca/ca.crt",
  ]

  # Variabili d'ambiente per Kibana
  kibana_env = [
    "ELASTICSEARCH_HOSTS=https://es01:9200",
    "ELASTICSEARCH_USERNAME=kibana_system",
    "ELASTICSEARCH_PASSWORD=${data.vault_generic_secret.kibana_password.data["ELASTICSEARCH_PASSWORD"]}",
    "ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=config/certs/ca/ca.crt",
    "XPACK_SECURITY_ENCRYPTIONKEY=tngAbrrnyWXrcPiOFO1KFkL0P6X9vjL4DVcwP+hmNQ8=",
    "XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=oYRnTIwkBDMDSaesXXqDKMmmJWxUylXEWjSaCgjY+y8=",
    "XPACK_REPORTING_ENCRYPTIONKEY=sjiMDN+E2rbWuOevZF2EtvYT7EfQwZBmtMm+Q5F9pDM=",
  ]

  # Variabili d'ambiente per Logstash (con password recuperata da Vault)
  logstash_env = [
    "ELASTICSEARCH_HOSTS=https://es01:9200",
    "ELASTICSEARCH_USERNAME=logstash_system",
    "ELASTICSEARCH_PASSWORD=${data.vault_generic_secret.elastic_password.data["ELASTIC_PASSWORD"]}",
    "XPACK_SECURITY_ENABLED=true",
    "XPACK_SECURITY_HTTP_SSL_CERTIFICATEAUTHORITIES=config/certs/ca/ca.crt",
  ]
}

module "setup" {
  source        = "./modules/setup"
  stack_version = var.stack_version
  network_name  = docker_network.elk-stack.name
}

module "elastic" {
  source          = "./modules/elasticsearch"
  stack_version   = var.stack_version
  network_name    = docker_network.elk-stack.name
  env             = local.elastic_env
  setup_service_id = module.setup.setup_service_id
}

module "kibana" {
  source          = "./modules/kibana"
  stack_version   = var.stack_version
  network_name    = docker_network.elk-stack.name
  env             = local.kibana_env
  setup_service_id = module.setup.setup_service_id
}

module "logstash" {
  source          = "./modules/logstash"
  stack_version   = var.stack_version
  network_name    = docker_network.elk-stack.name
  env             = local.logstash_env
  elastic_service_id = module.elastic.elastic_service_id
}