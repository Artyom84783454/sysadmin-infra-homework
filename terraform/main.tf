terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "docker" {}

# Create a Docker network
resource "docker_network" "app_network" {
  name = "${var.project_name}_network"
}

# Create a Docker volume
resource "docker_volume" "app_volume" {
  name = "${var.project_name}_volume"
}

# PHP-FPM container
resource "docker_container" "php" {
  name  = "${var.project_name}_php"
  image = "php:8-fpm"

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.app_volume.name
    container_path = "/var/www/html"
  }

  env = [
    "APP_ENV=${var.app_env}"
  ]
}

# Nginx container
resource "docker_container" "nginx" {
  name  = "${var.project_name}_nginx"
  image = "nginx:latest"

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.app_volume.name
    container_path = "/var/www/html"
  }

  ports {
    internal = 80
    external = var.host_port
  }

  env = [
    "APP_ENV=${var.app_env}"
  ]
}
