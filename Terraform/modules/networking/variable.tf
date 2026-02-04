# VPC
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "instance_tenancy" { default = "default" }

# Subnets
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "private_subnet1_cidr" {}
variable "private_subnet2_cidr" {}

variable "availability_zone_01" {}
variable "availability_zone_02" {}

variable "public_subnet1_name" {}
variable "public_subnet2_name" {}
variable "private_subnet1_name" {}
variable "private_subnet2_name" {}

# Internet Gateway & NAT
variable "igw_name" {}
variable "nat_eip_name" {}
variable "nat_gw_name" {}

# Route Tables
variable "public_rt_name" {}
variable "private_rt_name" {}

# Security Groups
variable "public_sg_name" {}
variable "private_sg_name" {}
variable "ssh_cidr" {}
variable "private_sg_cidr" {}

