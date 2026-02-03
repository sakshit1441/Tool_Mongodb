resource "aws_vpc" "mongo_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "mongo-vpc"
  }
}
resource "aws_subnet" "mongo_subnet" {
  vpc_id                  = aws_vpc.mongo_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "mongo-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mongo_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.mongo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.mongo_subnet.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_security_group" "mongo_sg" {
  vpc_id = aws_vpc.mongo_vpc.id
  name   = "mongo-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "mongodb_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.mongo_subnet.id
  vpc_security_group_ids = [aws_security_group.mongo_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "mongodb-server"
  }
}
