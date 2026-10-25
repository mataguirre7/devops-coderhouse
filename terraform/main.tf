terraform {
  required_version = ">= 1.3"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Modulo de red: crea la red donde corre la app (requisito "redes")
module "network" {
  source       = "./modules/network"
  network_name = var.network_name
}

# Construyo la imagen a partir del Dockerfile del proyecto
resource "docker_image" "app" {
  name = var.image_name
  build {
    context = "${path.module}/.."
  }
}

# "Instancia" de la aplicacion = contenedor corriendo la imagen
resource "docker_container" "app" {
  name  = var.container_name
  image = docker_image.app.image_id

  networks_advanced {
    name = module.network.network_name
  }

  ports {
    internal = 8080
    external = var.host_port
  }
}
