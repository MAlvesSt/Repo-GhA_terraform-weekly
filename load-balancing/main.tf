
# ====================
#   MAIN - Load-Bal
# ====================

# ALB - Application Load Balancer
# aws_lb.main
resource "aws_lb" "main" {
  # Nombre del ALB
  name = "malves-weekly-exercise-alb"

  # NO es privado (público)
  internal = false

  # Tipo de balanceador
  #  - application -> ALB: para tráfico HTTP/HTTPS (capa 7). Ideal para aplicaciones web.
  load_balancer_type = "application"

  # Asocia grupo de seguridad 
  #  - Definido anteriormente
  security_groups = [var.security_group_alb_id]

  # Especifica en qué subredes públicas se desplegará el ALB
  # Obtiene el id de los valores (objetos de subnet) dentro del mapa de subnets 
  subnets = values(var.public_subnet_list)[*].id

  # Tag para el ALB
  tags = { Name = "malves-weekly-exercise-alb" }
}

# Grupo de recursos de destino a los que el ALB puede enviar tráfico
# aws_lb_target_group.main
resource "aws_lb_target_group" "main" { 
  # Nombre del target group
  name = var.tg_name

  # Puerto al que el ALB enviará el tráfico en cada instancia
  port = var.alb_port

  # Protocolo que usa para comunicarse con las instancias
  protocol = "HTTP"

  # Asigna el TG a la VPC
  #  - Las instancias deben estar en la misma VPC
  vpc_id = var.vpc_id

  # Define como el ALB verifica si la instancia está sana
  health_check {
    # Ruta donde hace la petición web
    path = "/"

    # Cada 30 segundos verifica cada instancia
    interval = 30

    # Espera 5 segundos para recibir respuesta
    timeout = 5

    # Debe pasar 2 health checks para ser considerada sana
    healthy_threshold = 2

    # Debe fallar 2 health checks para ser considerada insana
    unhealthy_threshold = 2
  }
}

# Vincula cada instancia EC2 al target group
# así ALB sabe a que servidores enviar tráfico
# aws_lb_target_group_attachment.web
resource "aws_lb_target_group_attachment" "web" {
  # Recorre cada instancia EC2 creada
  for_each = var.ec2_instances

  # Especifica el TG al que se agregaran las instancias
  target_group_arn = aws_lb_target_group.main.arn

  # El ID de cada instancia EC2 a agregar
  target_id = each.value.id

  # Puerto en la instancia donde escucha 
  # Refuerza el puerto definido en ALB
  port = var.alb_port
}

# Listener
# Define cómo el ALB escucha el tráfico entrante y qué hace con él.
# aws_lb_listener.http
resource "aws_lb_listener" "http" {
  # Asocia este listener al ALB que ya creamos
  load_balancer_arn = aws_lb.main.arn

  # Puerto en el que el ALB escucha
  port = var.alb_port

  # Protocolo de entrada
  protocol = "HTTP"

  # Define la acción predeterminada cuando llega tráfico
  default_action {
    # Reenvía el tráfico
    type = "forward"

    # Envía el tráfico al Target group (donde están los EC2)
    target_group_arn = aws_lb_target_group.main.arn
  }
}

