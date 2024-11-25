variable "stack_version" {
  description = "The version of the stack"
  type = string
  default = "8.15.0"
  
}

variable "elastic_env" {
  description = "Elasticsearch environment variables"
  type = list(string)
  default = [
    "node.name=es01",
    "discovery.type=single-node",
    "ELASTIC_PASSWORD=password1",
    "xpack.security.enabled=true",
    "xpack.security.http.ssl.enabled=true",
    "xpack.security.http.ssl.key=/usr/share/elasticsearch/config/certs/es01/es01.key",
    "xpack.security.http.ssl.certificate=/usr/share/elasticsearch/config/certs/es01/es01.crt",
    "xpack.security.http.ssl.certificate_authorities=/usr/share/elasticsearch/config/certs/ca/ca.crt",
  ]
}

variable "kibana_env" {
  description = "Kibana environment variables"
  type = list(string)
  default = [
    "ELASTICSEARCH_HOSTS=https://es01:9200",
    "ELASTICSEARCH_USERNAME=kibana_system",
    "ELASTICSEARCH_PASSWORD=password1",
    "ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=config/certs/ca/ca.crt",
    "XPACK_SECURITY_ENCRYPTIONKEY=tngAbrrnyWXrcPiOFO1KFkL0P6X9vjL4DVcwP+hmNQ8=",
    "XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=oYRnTIwkBDMDSaesXXqDKMmmJWxUylXEWjSaCgjY+y8=",
    "XPACK_REPORTING_ENCRYPTIONKEY=sjiMDN+E2rbWuOevZF2EtvYT7EfQwZBmtMm+Q5F9pDM=",
  ]
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

