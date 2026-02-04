##########################################################
# VPC CIDR Block
##########################################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

##########################################################
# Public Subnet CIDRs
##########################################################
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

##########################################################
# Private Subnet CIDRs
##########################################################
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
