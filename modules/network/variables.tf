
# ====================
# VARIABLES - Network
# ====================

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Nombre para la VPC"
  type = string
}

variable "igw_name" {
  description = "Nombre de la Internet Gateway"
  type = string
}

variable "sb_name" {
  description = "Prefijo de nombre de las Subredes"
  type = string
}

variable "rt_name" {
  description = "Nombre de la Tabla de rutas"
  type = string
}


variable "public_subnet_cidrs" {
  description = "Lista de bloques CIDR para subredes publicas"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
