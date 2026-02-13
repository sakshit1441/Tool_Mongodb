##########################################################
# SECURITY GROUP – BASTION
##########################################################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP to Bastion"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Laptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

##########################################################
# SECURITY GROUP – MONGODB + EFS
##########################################################
resource "aws_security_group" "mongo_sg" {
  name        = "mongo-sg"
  description = "MongoDB & EFS access only from Bastion"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "MongoDB from Bastion"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "EFS NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
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

##########################################################
# BASTION EC2 (PUBLIC SUBNET)
##########################################################
resource "aws_instance" "bastion" {
  ami                         = var.mongo_ami
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "mongo-bastion"
  }
}

##########################################################
# MONGODB EC2 INSTANCES (PRIVATE SUBNETS)
##########################################################
resource "aws_instance" "mongo" {
  count                  = length(var.private_subnets)
  ami                    = var.mongo_ami
  instance_type          = var.mongo_instance_type
  subnet_id              = var.private_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.mongo_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "mongo-instance-${count.index}"
  }
}

##########################################################
# EFS FILE SYSTEM
##########################################################
resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "mongo-efs"
  }
}

##########################################################
# EFS MOUNT TARGETS
##########################################################
resource "aws_efs_mount_target" "mongo_efs_mount" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.mongo_efs.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.mongo_sg.id]
}
