
# ====================
#   MAIN - Security
# ====================


# Security Group para instancias EC2 (permitir tráfico desde ALB)
# aws_security_group.instance
resource "aws_security_group" "instance" {
  # Prefijo para los nombres de los sg para EC2 a crear
  name_prefix = "${var.sg_ins_name}-"

  # Id de la VPC. La creada anteriormente [LA ASOCIA]
  vpc_id = var.vpc_id

  # Configuracion de entrada
  ingress {
    # Definicion de rango de puertos
    # En este caso, es sólo 1 puerto, por lo que es el mismo 
    from_port = var.alb_port
    to_port = var.alb_port

    # Protocolo que usa
    protocol = "tcp"

    # Id del Grupo de seguridad del ALB (Creado más adelante)
    # Objetivo: solo queremos que el ALB pueda comunicarse con las instancias
    security_groups = [aws_security_group.alb.id]
  }

  # Configuración de salida 
  egress {
    # Con estos puertos y protocolos permite todo tráfico saliente
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] # A cualquier destino
  }

  # Tag del security group para las instancias
  tags = { Name = var.sg_ins_name }
}

# Security Group para ALB (permitir tráfico desde internet)
# aws_security_group.alb
resource "aws_security_group" "alb" {
  # Prefijo para los nombres de los security group de alb a crear
  name_prefix = "${var.sg_alb_name}-"

  # Id de la VPC. La creada anteriormente [LA ASOCIA]
  vpc_id = var.vpc_id

  # Configuracion de entrada
  ingress {
    from_port = var.alb_port
    to_port = var.alb_port # Rango de puertos
    protocol = "tcp" # Protocolo
    # Objetivo: permitir que cualquier usuario en internet acceda a tu aplicación web.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Configuración de salida 
  egress {
    # Con estos puertos y protocolos permite todo tráfico saliente
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] # A cualquier destino
  }

  # Tag del security group de alb
  tags = { Name = var.sg_alb_name }
}
