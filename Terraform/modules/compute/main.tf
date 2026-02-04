##########################################
# VARIABLES (defined in variables.tf)
# - vpc_id
# - private_subnets
# - mongo_ami
# - mongo_instance_type
# - key_name
##########################################

# Security Group for MongoDB
resource "aws_security_group" "mongo_sg" {
  name        = "mongo-sg"
  description = "MongoDB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to your trusted IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mongo-sg"
  }
}

# MongoDB EC2 Instances in Private Subnets

resource "aws_instance" "mongo" {
  count                     = length(var.private_subnets)
  ami                       = var.mongo_ami
  instance_type             = var.mongo_instance_type
  subnet_id                 = var.private_subnets[count.index]
  vpc_security_group_ids    = [aws_security_group.mongo_sg.id]
  key_name                  = var.key_name
  associate_public_ip_address = false

  tags = {
    Name = "mongo-instance-${count.index}"
  }
}

# EFS File System for MongoDB Data

resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "mongo-efs"
  }
}

# EFS Mount Targets in each Private Subnet

resource "aws_efs_mount_target" "mongo_efs_mount" {
  count          = length(var.private_subnets)
  file_system_id = aws_efs_file_system.mongo_efs.id
  subnet_id      = var.private_subnets[count.index]
  security_groups = [aws_security_group.mongo_sg.id]
}

