terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "setup" {
  name         = "docker.elastic.co/elasticsearch/elasticsearch:${var.stack_version}"
  keep_locally = true
}

resource "docker_volume" "certs" {
  name   = "certs"
  driver = "local"
}


resource "docker_container" "setup" {
  name  = "setup"
  image = docker_image.setup.name

  user = "root"

  volumes {
    container_path = "/usr/share/elasticsearch/config/certs"
    volume_name    = docker_volume.certs.name
  }

  command = [
    "bash", "-c",
    <<-EOF
      if [ ! -f config/certs/ca.zip ]; then
        echo "Creating CA";
        bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip;
        unzip config/certs/ca.zip -d config/certs;
      fi;
      if [ ! -f config/certs/certs.zip ]; then
        echo "Creating certs";
        echo -ne \
        "instances:\n"\
        "  - name: es01\n"\
        "    dns:\n"\
        "      - es01\n"\
        "      - localhost\n"\
        "    ip:\n"\
        "      - 127.0.0.1\n"\
        "  - name: kibana\n"\
        "    dns:\n"\
        "      - kibana\n"\
        "      - localhost\n"\
        "    ip:\n"\
        "      - 127.0.0.1\n"\
        "  - name: logstash\n"\
        "    dns:\n"\
        "      - logstash\n"\
        "      - localhost\n"\
        "    ip:\n"\
        "      - 127.0.0.1\n"\
        > config/certs/instances.yml;
        bin/elasticsearch-certutil cert --silent --pem -out config/certs/certs.zip --in config/certs/instances.yml --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key;
        unzip config/certs/certs.zip -d config/certs;
      fi;
      echo "Setting file permissions";
      chown -R root:root config/certs;
      
      find . -type d -exec chmod 750 {} \;;
      find . -type f -exec chmod 640 {} \;;
      echo "Waiting for Elasticsearch availability";
      until curl -s --cacert config/certs/ca/ca.crt https://es01:9200 | grep -q "missing authentication credentials"; do sleep 30; done;
      echo "Setting kibana_system password";
      until curl -s -X POST --cacert config/certs/ca/ca.crt -u "elastic:password1" -H "Content-Type: application/json" https://es01:9200/_security/user/kibana_system/_password -d "{\"password\":\"password1\"}" | grep -q "^{}"; do sleep 10; done;
      echo "All done!";
    EOF
  ]

  healthcheck {
    test     = ["CMD-SHELL", "[ -f config/certs/es01/es01.crt ]"]
    interval = "1s"
    timeout  = "5s"
    retries  = 120
  }

  restart = "no"

  networks_advanced {
    name = var.network_name
  }
}
