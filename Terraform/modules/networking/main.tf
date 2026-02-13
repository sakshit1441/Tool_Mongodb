##########################################################
# AVAILABILITY ZONES
##########################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##########################################################
# VPC
##########################################################

resource "aws_vpc" "mongo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "mongo-vpc"
  }
}

##########################################################
# INTERNET GATEWAY
##########################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mongo_vpc.id

  tags = {
    Name = "mongo-igw"
  }
}

##########################################################
# PUBLIC SUBNETS (FOR BASTION / NAT)
##########################################################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.mongo_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

##########################################################
# PRIVATE SUBNETS (FOR MONGODB + EFS)
##########################################################

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.mongo_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

##########################################################
# PUBLIC ROUTE TABLE
##########################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mongo_vpc.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

##########################################################
# NAT GATEWAY (FOR PRIVATE SUBNET INTERNET ACCESS)
##########################################################

resource "aws_eip" "nat" {
  
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-gateway"
  }
}

##########################################################
# PRIVATE ROUTE TABLE
##########################################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mongo_vpc.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
