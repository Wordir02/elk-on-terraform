
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}


module "setup" {
  source = "./modules/setup"
  stack_version = var.stack_version
  network_name = docker_network.elk-stack.name
}


module "elastic"{
  source = "./modules/elasticsearch"
  stack_version = var.stack_version
  network_name = docker_network.elk-stack.name
  env = var.elastic_env
  setup_service_id = module.setup.setup_service_id 
 
}

module "kibana"{
  source = "./modules/kibana"
  stack_version = var.stack_version
  network_name = docker_network.elk-stack.name
  env = var.kibana_env
  setup_service_id = module.setup.setup_service_id
}

module "logstash"{
  source = "./modules/logstash"
  stack_version = var.stack_version
  network_name = docker_network.elk-stack.name
   env = var.logstash_env
  elastic_service_id = module.elastic.elastic_service_id
}


