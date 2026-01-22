
# ====================
#   OUTPUT - Network
# ====================

output "vpc_id" {
  description = "ID de la VPC creada"
  value = aws_vpc.main.id
}

# output "public_subnet_ids" {
#   description = "IDs de las subnets públicas"
#   value = values(aws_subnet.public)[*].id
# }

output "public_subnet_list" {
  description = "Mapa de subnets públicas"
  value = aws_subnet.public
}