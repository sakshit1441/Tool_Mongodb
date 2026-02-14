##########################################
# NETWORKING OUTPUTS
##########################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnets
}

##########################################
# COMPUTE / MONGODB OUTPUTS
##########################################

output "mongo_private_ips" {
  description = "Private IP addresses of MongoDB EC2 instances"
  value       = module.compute.mongo_private_ips
}

output "mongo_instance_ids" {
  description = "MongoDB EC2 instance IDs"
  value       = module.compute.mongo_instance_ids
}

##########################################
# BASTION OUTPUT
##########################################

output "bastion_public_ip" {
  description = "Public IP address of Bastion host"
  value       = module.compute.bastion_public_ip
}

##########################################
# EFS OUTPUT
##########################################

output "efs_id" {
  description = "EFS File System ID for MongoDB"
  value       = module.compute.efs_id
}
