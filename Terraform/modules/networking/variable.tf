##########################################################
# VPC CONFIGURATION
##########################################################

variable "vpc_cidr" {
  description = "CIDR block for the MongoDB VPC"
  type        = string
}

##########################################################
# PUBLIC SUBNET CONFIGURATION
##########################################################

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (Bastion, NAT Gateway)"
  type        = list(string)
}

##########################################################
# PRIVATE SUBNET CONFIGURATION
##########################################################

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (MongoDB, EFS)"
  type        = list(string)
}
