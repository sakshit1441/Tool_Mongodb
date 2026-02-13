##########################################
# MONGODB EC2 OUTPUTS
##########################################

output "mongo_private_ips" {
  description = "Private IP addresses of MongoDB EC2 instances"
  value       = aws_instance.mongo[*].private_ip
}

output "mongo_instance_ids" {
  description = "Instance IDs of MongoDB EC2 instances"
  value       = aws_instance.mongo[*].id
}

##########################################
# BASTION OUTPUT
##########################################

output "bastion_public_ip" {
  description = "Public IP address of Bastion Host"
  value       = aws_instance.bastion.public_ip
}

##########################################
# EFS OUTPUT
##########################################

output "efs_id" {
  description = "EFS File System ID for MongoDB"
  value       = aws_efs_file_system.mongo_efs.id
}
