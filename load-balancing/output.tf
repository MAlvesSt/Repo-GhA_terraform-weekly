
# ====================
#  OUTPUT - Load-Bal
# ====================

output "alb_dns_name" {
  description = "nombre DNS del ALB"
  value = aws_lb.main.dns_name
}