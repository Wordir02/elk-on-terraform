variable "stack_version" {
  description = "The version of the stack"
  type = string
  default = "8.15.0"
  
}



variable "logstash_env" {
  description = "Logstash environment variables"
  type = list(string)
  default = [
    "NODE_NAME=logstash",
    "ELASTICSEARCH_HOSTS=https://es01:9200",
    "ELASTIC_USER=elastic",
    "ELASTIC_PASSWORD=password1",
  ]
}


