variable "image_name" {
  description = "Nombre de la imagen Docker a construir"
  type        = string
  default     = "devops-coderhouse:local"
}

variable "container_name" {
  description = "Nombre del contenedor"
  type        = string
  default     = "nginx-app"
}

variable "network_name" {
  description = "Nombre de la red Docker"
  type        = string
  default     = "nginx-net"
}

variable "host_port" {
  description = "Puerto del host donde se expone la app"
  type        = number
  default     = 8080
}
