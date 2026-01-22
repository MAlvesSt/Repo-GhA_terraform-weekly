
# ====================
# VARIABLES - Security
# ====================

variable "alb_port" {
  description = "Puerto para el ALB listener"
  type = number
}

variable "vpc_id" {
  description = "ID de la VPC creada"
}

variable "sg_ins_name" {
  description = "Nombre para el security group de instances"
  type = string
}

variable "sg_alb_name" {
  description = "Nombre para el security group de alb"
  type = string
}
