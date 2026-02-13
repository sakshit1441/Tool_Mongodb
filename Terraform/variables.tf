##########################################
# AWS CONFIGURATION
##########################################

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

##########################################
# NETWORKING CONFIGURATION
##########################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

##########################################
# COMPUTE CONFIGURATION (MONGODB + BASTION)
##########################################

variable "mongo_instance_type" {
  description = "EC2 instance type for MongoDB nodes"
  type        = string
}

variable "mongo_ami" {
  description = "AMI ID for MongoDB and Bastion EC2 instances"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 key pair name for SSH access"
  type        = string
}

