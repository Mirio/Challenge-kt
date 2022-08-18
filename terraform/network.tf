resource "aws_vpc" "main_vpc" {
  cidr_block           = var.network_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.global_tags, { "Name" : "CHALLENGEKT" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

# Subnet Private Part
resource "aws_subnet" "subnet_private_a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subneta_private
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PRIVATE_A" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subnetb_private
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PRIVATE_B" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subnetc_private
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PRIVATE_C" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

# Subnet Public Part
resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subneta_public
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PUBLIC_A" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_subnet" "subnet_public_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subnetb_public
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PUBLIC_B" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_subnet" "subnet_public_c" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.network_subnetc_public
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PUBLIC_C" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

# Internet GW
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.global_tags, { "Name" : "CHALLENGEKT_IGW" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_eip" "main_eipnatgw" {
  vpc  = true
  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_NATGWEIP" }, { "kubernetes.io/cluster/${var.cluster_name}" : "shared" }, )
}

resource "aws_nat_gateway" "main_natgw" {
  allocation_id = aws_eip.main_eipnatgw.id
  subnet_id     = aws_subnet.subnet_public_a.id
  tags          = merge(var.global_tags, { "Name" : "CHALLENGEKT_NATGW" })
}

# Routing Tables
resource "aws_default_route_table" "main_rt_private" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_natgw.id
  }

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PRIVATE" })
}

resource "aws_route_table" "main_rt_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_PUBLIC" })
}

resource "aws_route_table_association" "main_rt_privatea_asso" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_default_route_table.main_rt_private.id
}

resource "aws_route_table_association" "main_rt_privateb_asso" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_default_route_table.main_rt_private.id
}

resource "aws_route_table_association" "main_rt_privatec_asso" {
  subnet_id      = aws_subnet.subnet_private_c.id
  route_table_id = aws_default_route_table.main_rt_private.id
}

resource "aws_route_table_association" "main_rt_publica_asso" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_route_table.main_rt_public.id
}

resource "aws_route_table_association" "main_rt_publicb_asso" {
  subnet_id      = aws_subnet.subnet_public_b.id
  route_table_id = aws_route_table.main_rt_public.id
}

resource "aws_route_table_association" "main_rt_publicc_asso" {
  subnet_id      = aws_subnet.subnet_public_c.id
  route_table_id = aws_route_table.main_rt_public.id
}

# Security Groups default restricts all traffic
resource "aws_default_security_group" "default_sg_restrict" {
  vpc_id = aws_vpc.main_vpc.id
}

# Security Groups
resource "aws_security_group" "main_sg_controlplan" {
  name        = "CHALLENGEKT_EC2_CONTROLPLANE"
  description = "Main Trafic for EC2 instances"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip
  }

  ingress {
    description = "Kubectl access"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic from nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.network_cidr]
  }

  egress {
    description = "Allow Out traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_EC2_CONTROLPLANE" })
}

resource "aws_security_group" "main_sg_node" {
  name        = "CHALLENGEKT_EC2_NODE"
  description = "Main Trafic for EC2 instances"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip
  }

  ingress {
    description = "Allow all traffic from nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.network_cidr]
  }

  egress {
    description = "Allow Out traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.global_tags, { "Name" : "CHALLENGEKT_EC2_NODE" })
}
