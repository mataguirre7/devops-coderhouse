output "app_url" {
  description = "URL local para acceder a la aplicacion"
  value       = "http://localhost:${var.host_port}"
}

output "container_name" {
  value = docker_container.app.name
}
