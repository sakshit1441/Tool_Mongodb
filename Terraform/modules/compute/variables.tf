# --------------------------
# Security Groups
# --------------------------
variable "sg_bastion_id" {
  type = string
}

variable "sg_mongo_id" {
  type = string
}

# --------------------------
# Subnets
# --------------------------
variable "public_subnet_id" {
  type = string
}

variable "private_subnet01_id" {
  type = string
}

variable "private_subnet02_id" {
  type = string
}

# --------------------------
# EC2 Instances
# --------------------------
variable "AMI_ID" {
  type    = string
  default = "ami-0d53d72369335a9d6"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "ansible-key"
}

variable "bastion_name" {
  type    = string
  default = "MongoDB-Bastion"
}

variable "mongodb01_name" {
  type    = string
  default = "MongoDB-01"
}

variable "mongodb02_name" {
  type    = string
  default = "MongoDB-02"
}

# --------------------------
# Optional Internal Load Balancer
# --------------------------
variable "vpc_id" {
  type = string
}

variable "mongo_tg_name" {
  type    = string
  default = "mongo-tg"
}

variable "mongo_lb_name" {
  type    = string
  default = "mongo-alb"
}

variable "ALB_type" {
  type    = string
  default = "application"
}

variable "internal_value" {
  type    = bool
  default = true
}

variable "mongo_lb_port" {
  type    = string
  default = "27017"
}

variable "Target_group_arn" {
  type = string
}

variable "ALB_arn" {
  type = string
}

variable "private01_vm_id" {
  type = string
}

variable "private02_vm_id" {
  type = string
}

