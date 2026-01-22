
# ====================
#  OUTPUT - Instance
# ====================

output "ec2_instances" {
  description = "Mapa de instancias EC2 creadas, con sus atributos principales"
  value = aws_instance.web
}