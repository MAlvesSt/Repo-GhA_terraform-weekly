
# ====================
#   MAIN - Instance
# ====================


# Instancias EC2
# aws_instance.web
resource "aws_instance" "web" {
  # Recorre la variable instances
  # Cada instancia será como -> aws_instance.web["app1"]
  for_each = var.instances

  # Valor AMI para cada instancia
  #  - Lo toma del valor definido en la variable que itera
  ami = each.value.ami

  # Tipo de instancia
  #  - Lo toma del valor definido en la variable que itera
  instance_type = each.value.instance_type

  # Asigna cada instancia a una subnet pública de forma rotativa para distribuir
  # la carga entre zonas de disponibilidad (alta disponibilidad)
  subnet_id = element(values(var.public_subnet_list)[*].id, index(keys(var.instances), each.key) % length(var.public_subnet_list))

  # Asigna el security group creado para las instancias a la instancia 
  vpc_security_group_ids = [var.security_group_instance_id]

  # Tag para cada instacia
  #  - Lo toma del valor definido en la variable que itera
  tags = each.value.tags
}
