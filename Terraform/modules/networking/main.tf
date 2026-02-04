############################################
# VPC
############################################
resource "aws_vpc" "mongodb_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

############################################
# Subnets
############################################
# Public subnets
resource "aws_subnet" "public01" {
  vpc_id                  = aws_vpc.mongodb_vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.availability_zone_01
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet1_name
  }
}

resource "aws_subnet" "public02" {
  vpc_id                  = aws_vpc.mongodb_vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.availability_zone_02
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet2_name
  }
}

# Private subnets
resource "aws_subnet" "private01" {
  vpc_id            = aws_vpc.mongodb_vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.availability_zone_01

  tags = {
    Name = var.private_subnet1_name
  }
}

resource "aws_subnet" "private02" {
  vpc_id            = aws_vpc.mongodb_vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.availability_zone_02

  tags = {
    Name = var.private_subnet2_name
  }
}

############################################
# Internet Gateway
############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mongodb_vpc.id

  tags = {
    Name = var.igw_name
  }
}

############################################
# Elastic IP for NAT
############################################
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = var.nat_eip_name
  }
}

############################################
# NAT Gateway
############################################
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public01.id

  tags = {
    Name = var.nat_gw_name
  }

  depends_on = [aws_internet_gateway.igw]
}

############################################
# Route Tables
############################################
# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mongodb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_rt_name
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mongodb_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = var.private_rt_name
  }
}

############################################
# Route Table Associations
############################################
# Public subnets
resource "aws_route_table_association" "public01_assoc" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public02_assoc" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.public_rt.id
}

# Private subnets
resource "aws_route_table_association" "private01_assoc" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private02_assoc" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.private_rt.id
}

############################################
# Security Groups
############################################
# Public SG (SSH + HTTP)
resource "aws_security_group" "public_sg" {
  name   = var.public_sg_name
  vpc_id = aws_vpc.mongodb_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.public_sg_name
  }
}

# Private SG (MongoDB + Monitoring + NFS)
resource "aws_security_group" "private_sg" {
  name   = var.private_sg_name
  vpc_id = aws_vpc.mongodb_vpc.id

  # MongoDB port
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.private_sg_cidr]
  }

  # SSH from public SG
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # NFS (EFS) port
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.private_sg_name
  }
}

############################################
# EFS (for MongoDB backups/logs)
############################################
resource "aws_efs_file_system" "mongodb_efs" {
  creation_token   = "${var.vpc_name}-efs"
  performance_mode = "generalPurpose"
  encrypted        = true

  tags = {
    Name = "${var.vpc_name}-efs"
  }
}

# Mount Targets in Private Subnets
resource "aws_efs_mount_target" "efs_private01" {
  file_system_id  = aws_efs_file_system.mongodb_efs.id
  subnet_id       = aws_subnet.private01.id
  security_groups = [aws_security_group.private_sg.id]
}

resource "aws_efs_mount_target" "efs_private02" {
  file_system_id  = aws_efs_file_system.mongodb_efs.id
  subnet_id       = aws_subnet.private02.id
  security_groups = [aws_security_group.private_sg.id]
}

