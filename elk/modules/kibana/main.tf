terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "kibana" {
  name = "docker.elastic.co/kibana/kibana:${var.stack_version}"
  keep_locally = true
}

resource "docker_volume" "certs" {
  name   = "certs"
  driver = "local"
}

resource "docker_volume" "kibanadata" {
  name   = "kibanadata"
  driver = "local"
}


resource "docker_container" "kibana" {
  depends_on = [ var.setup_service_id ]
  name  = "kibana"
  image = docker_image.kibana.name
 

  labels {
    label = "co.elastic.logs/module"
    value = "kibana"
  }

  volumes {
    container_path = "/usr/share/kibana/config/certs"
    volume_name = docker_volume.certs.name
  }

  volumes {
    container_path = "/usr/share/kibana/data"
    volume_name = docker_volume.kibanadata.name
  }

  env = var.env


  ports {
    internal = 5601
    external = 5601
    protocol = "tcp"
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -s -I http://localhost:5601 | grep -q 'HTTP/1.1 302 Found'"]
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
