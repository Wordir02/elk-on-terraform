variable "network_name" {
  description = "The name of the Docker network"
  type = string
}

variable "elastic_service_id" {
  description = "ID del servizio Elasticsearch a cui Kibana deve fare riferimento"
  type = string
}

variable "stack_version" {
  description = "The version of the stack"
  type = string
}

variable "env" {
  description = "Environment variables for Logstash container"
  type = list(string)
}
