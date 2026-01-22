
# ====================
#    MAIN - Network
# ====================

# VPC - Red virtual privada
# "aws_vpc" -> Tipo de recurso que creamos
# "main" -> Nombre local que se le da a la VPC
# aws_vpc.main
resource "aws_vpc" "main" {
  # Rango de direcciones ip que usa la VPC
  cidr_block = var.vpc_cidr

  # Tag de la VPC
  tags = { Name = var.vpc_name }
}


# Internet Gateway
# "aws_internet_gateway" -> Tipo de recurso que creamos
# "gw" -> Nombre local que se le da a la Gateway
# aws_internet_gateway.gw
resource "aws_internet_gateway" "gw" {
  # Id de la vpc. La toma de la VPC creada anteriormente [LA ASOCIA]
  vpc_id = aws_vpc.main.id
  
  # Tag de la Internet GateWay
  tags = { Name = var.igw_name }
}

# Subnets públicas
# "aws_subnet" -> Tipo de recurso que creamos
# "public" -> Nombre local que se le da a las subnets
# aws_subnet.public
resource "aws_subnet" "public" {
  # Convierte en set y recorre todas las subnets definidas en la variable
  for_each = toset(var.public_subnet_cidrs)


  # Id de la VPC. La creada anteriormente [LA ASOCIA]
  vpc_id = aws_vpc.main.id

  # Rango de direcciones IP para cada subnet
  # each.value -> Refiere al valor de la iteracion actual
  cidr_block = each.value

  # Zona de disponibilidad para cada subnet
  #  - data.(...).names -> Obtiene una lista de Avaliability Zones (AZ) disponibles en la región
  #  - index(var.public_subnet_cidrs, each.value) -> Obtiene la posicion del CIDR actual en la lista (0,1,2,...)
  #  - element(lista, indice) -> Devuelve el elemento en esa posición
  # Esto asegura alta disponibilidad (los recursos no están todos en la misma AZ)
  # Por ejemplo -> 10.0.1.0/24 en eu-west-3a  |  10.0.2.0/24 en eu-west-3b
  availability_zone = element(data.aws_availability_zones.available.names, index(var.public_subnet_cidrs, each.value))

  # Habilita IPs públicas automáticas para cualquier EC2 en la subnet
  # Sin esto -> Solo tendrían Ips privadas y no serían accesibles
  map_public_ip_on_launch = true
  
  # Etiqueta cada subnet -> public-10.0.1.0/24
  tags = { Name = "${var.sb_name}${each.key}" }
}

# Route Table para subnets públicas
# Permite que el tráfico saliente de las subnets públicas vayan a internet
# aws_route_table.public
resource "aws_route_table" "public" {
  # Id de la VPC. La creada anteriormente [LA ASOCIA]
  vpc_id = aws_vpc.main.id
  route {
    # Notación para "cualquier destino en internet"
    cidr_block = "0.0.0.0/0"
    
    # El tráfico debe salir por la Internet Gateway que se creó antes
    gateway_id = aws_internet_gateway.gw.id
  }

  # Tag de la tabla de rutas
  tags = { Name = var.rt_name }
}

# Asocia la tabla de rutas a la subnet
# aws_route_table_association.public
resource "aws_route_table_association" "public" {
  # Por cada subnet definida como "public" (las creadas anteriormente)
  for_each = aws_subnet.public

  # Id de la subnet. La toma de la subnet que itera
  subnet_id = each.value.id
  
  # Id de la tabla de ruta. La toma de la creada anteriormente
  route_table_id = aws_route_table.public.id
}

# Datos auxiliares
# Bloque de datos que recoje de AWS las zonas de disponibilidad (AZ) activas (available) en la region
# Se una para obtener los nombres de las AZs disponibles para distribuir las subredes
# aws_availability_zones.available
data "aws_availability_zones" "available" {
  state = "available"
}