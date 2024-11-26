terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "elasticsearch" {
  name = "docker.elastic.co/elasticsearch/elasticsearch:${var.stack_version}"
  keep_locally = true
}


resource "docker_volume" "certs" {
  name = "certs"
  driver = "local"
}

resource "docker_volume" "esdata01" {
  name = "esdata01"
  driver = "local"
}


resource "docker_container" "es01" {
  depends_on = [ var.setup_service_id ]
  name = "es01"
  image = docker_image.elasticsearch.name


  labels {
    label = "co.elastic.logs/module"
    value = "elasticsearch"
  }


   volumes {
    container_path = "/usr/share/elasticsearch/config/certs"
    volume_name = docker_volume.certs.name
  }

  volumes {
    container_path = "/usr/share/elasticsearch/data"
    volume_name = docker_volume.esdata01.name
  }

  env = var.env
    


  ports {
    internal = 9200
    external = 9200
    protocol = "tcp"
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -s --cacert config/certs/ca/ca.crt https://localhost:9200 | grep -q 'missing authentication credentials'"]
    interval = "10s"
    timeout  = "10s"
    retries  = 120
  }


  memory  = 1073741824
  restart = "on-failure"

  networks_advanced {
    name = var.network_name
  }
}
