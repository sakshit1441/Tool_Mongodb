##########################################
# AWS Provider Region
##########################################
variable "aws_region" {
  description = "AWS Region where resources will be deployed"
  type        = string
  default     = "ap-south-1"
}

##########################################
# VPC Configuration
##########################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

##########################################
# MongoDB EC2 Configuration
##########################################
variable "mongo_instance_type" {
  description = "EC2 instance type for MongoDB nodes"
  type        = string
  default     = "t3.medium"
}

variable "mongo_ami" {
  description = "AMI ID for MongoDB EC2 instances (Amazon Linux 2)"
  type        = string
  default     = "ami-0aeeebd8d2ab47354"  # Change if needed
}

variable "key_name" {
  description = "AWS EC2 Key Pair name for SSH access"
  type        = string
}

