
# ====================
#  OUTPUT - Security
# ====================

output "security_group_instance_id" {
  description = "ID de Security group creado para instancias EC2"
  value = aws_security_group.instance.id
}

output "security_group_alb_id" {
  description = "ID de Security group creado para Load Balancer"
  value = aws_security_group.alb.id
}