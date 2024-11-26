terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "vault" {
  name = "hashicorp/vault:latest"
  keep_locally = true
}

resource "docker_container" "vault" {
  name  = "vault"
  image = docker_image.vault.name

  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=${var.vault_root_token}",
    "VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200"
  ]

  ports {
    internal = 8200
    external = var.vault_external_port
    protocol = "tcp"
  }

  volumes {
    container_path = "/vault/data"
    host_path      = var.vault_data_path
  }

  restart = "always"
}

output "vault_address" {
  value = "http://${var.vault_host}:${var.vault_external_port}"
}
