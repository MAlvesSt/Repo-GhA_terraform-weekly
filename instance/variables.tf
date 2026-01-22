
# ====================
# VARIABLES - Instance
# ====================


variable "instances" {
  description = "Map de instancias a crear"
  type = map(object({
    instance_type = string
    ami = string
    tags = map(string)
  }))
  default = {
    web1 = {
      instance_type = "t3.micro"
      ami = "ami-003db334c07d8c170" # Ubuntu 22.04 en eu-west-3
      tags = { Name = "web1" }
    }
    web2 = {
      instance_type = "t3.micro"
      ami = "ami-003db334c07d8c170"
      tags = { Name = "web2" }
    }
  }
}

# variable "public_subnet_ids" {
#   description = "IDs de las subnets públicas"
#   type = list(string)
# }

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

variable "security_group_instance_id" {
  description = "ID de Security group creado para instancias EC2"
  type = string
}