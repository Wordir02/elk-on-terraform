variable "network_name" {
  description = "The name of the Docker network"
  type = string
}


variable "setup_service_id" {
  description = "ID del servizio setup a cui elastic deve fare riferimento"
  type = string
}


variable "stack_version" {
  description = "The version of the stack"
  type = string
}


variable "env" {
  description = "Environment variables for Kibana container"
  type = list(string)
}
