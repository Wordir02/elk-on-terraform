terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "logstash" {
  name = "docker.elastic.co/logstash/logstash:${var.stack_version}"
  keep_locally = true
}


resource "docker_volume" "certs" {
  name = "certs"
  driver = "local"
}

resource "docker_volume" "logstashdata" {
  name = "logstashdata"
  driver = "local"
}


resource "docker_container" "logstash" {
  depends_on = [var.elastic_service_id]
  name  = "logstash"
  image = docker_image.logstash.name
  user = "root" 

  labels {
    label = "co.elastic.logs/module"
    value = "logstash"
  }

  volumes {
    container_path = "/usr/share/logstash/certs"
    volume_name    = docker_volume.certs.name
  }

  volumes {
    container_path = "/usr/share/logstash/data"
    volume_name    = docker_volume.logstashdata.name
  }

  volumes {
    container_path = "/usr/share/logstash/pipeline/logstash.conf"
    host_path      = "/home/wordir/elk-on-terraform/${path.module}/logstash.conf"
  }

  volumes {
    container_path = "/usr/share/logstash/config/logstash.yml"
    host_path      = "/home/wordir/elk-on-terraform/${path.module}/logstash.yml"
  }

 env = var.env

  command = ["logstash", "-f", "/usr/share/logstash/pipeline/logstash.conf"]

  ports {
    internal = 5044
    external = 5044
    protocol = "tcp"
  }

  memory  = 558345748
  restart = "on-failure"

  networks_advanced {
    name = var.network_name
  }
}
