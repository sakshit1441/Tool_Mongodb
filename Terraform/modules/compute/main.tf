# --------------------------
# Bastion Host (Public EC2)
# --------------------------
resource "aws_instance" "bastion" {
  ami                         = var.AMI_ID
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.sg_bastion_id]
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  tags = {
    Name = "MongoDB-Bastion"
  }
}

# --------------------------
# MongoDB Private Instances
# --------------------------
resource "aws_instance" "mongodb_01" {
  ami                    = var.AMI_ID
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_mongo_id]
  subnet_id              = var.private_subnet01_id

  tags = {
    Name = "MongoDB-01"
  }
}

resource "aws_instance" "mongodb_02" {
  ami                    = var.AMI_ID
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_mongo_id]
  subnet_id              = var.private_subnet02_id

  tags = {
    Name = "MongoDB-02"
  }
}

# --------------------------
# Security Groups
# --------------------------
# Bastion SG (SSH from Internet)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from Internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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

# MongoDB SG (Allow traffic only from Bastion)
resource "aws_security_group" "mongo_sg" {
  name        = "mongo-sg"
  description = "Allow MongoDB traffic from Bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------
# Optional Internal Load Balancer
# --------------------------
resource "aws_lb" "mongo_alb" {
  name               = "mongo-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mongo_sg.id]
  subnets            = [var.private_subnet01_id, var.private_subnet02_id]
}

resource "aws_lb_target_group" "mongo_tg" {
  name     = "mongo-tg"
  port     = 27017
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "mongo_tg_attach_01" {
  target_group_arn = aws_lb_target_group.mongo_tg.arn
  target_id        = aws_instance.mongodb_01.id
  port             = 27017
}

resource "aws_lb_target_group_attachment" "mongo_tg_attach_02" {
  target_group_arn = aws_lb_target_group.mongo_tg.arn
  target_id        = aws_instance.mongodb_02.id
  port             = 27017
}

