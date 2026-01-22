
# ====================
# VARIABLES - Load-Bal
# ====================

variable "alb_port" {
  description = "Puerto para el ALB listener"
  type = number
}

# variable "alb_name" {
#   description = "Nombre para ALB"
#   type = string
# }

variable "tg_name" {
  description = "Nombre para Target Group"
  type = string
}

variable "vpc_id" {
  description = "ID de la VPC creada"
  type = string
}

variable "security_group_alb_id" {
  description = "ID de Security group creado para Load Balancer"
  type = string
}

variable "public_subnet_list" {
  description = "Mapa de subnets públicas"
  type = map(object({
    id = string
    vpc_id = string
    availability_zone = string
    cidr_block = string
    map_public_ip_on_launch = bool
    tags = map(string)
  }))
}


variable "ec2_instances" {
  description = "Mapa de instancias EC2 con sus metadatos"
  type = map(object({
    id = string
    ami = string
    instance_type = string
    subnet_id = string
    vpc_security_group_ids = list(string)
    tags = map(string)
  }))
}
 
