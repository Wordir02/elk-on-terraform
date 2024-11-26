resource "docker_network" "elk-stack" {
  name = "elk-stack"
  driver = "bridge"
  attachable = true
  check_duplicate = true


ipam_config {
    subnet = "10.1.0.0/24"  
  }

}


