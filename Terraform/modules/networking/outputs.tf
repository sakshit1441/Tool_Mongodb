############################################
# VPC
############################################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.mongodb_vpc.id
}

############################################
# Subnets
############################################
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public01.id, aws_subnet.public02.id]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private01.id, aws_subnet.private02.id]
}

############################################
# Internet Gateway
############################################
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

############################################
# NAT Gateway
############################################
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gw.id
}

############################################
# Route Tables
############################################
output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private_rt.id
}

############################################
# Security Groups
############################################
output "public_sg_id" {
  description = "Public Security Group ID"
  value       = aws_security_group.public_sg.id
}

output "private_sg_id" {
  description = "Private Security Group ID"
  value       = aws_security_group.private_sg.id
}

############################################
# EFS
############################################
output "efs_id" {
  description = "EFS File System ID"
  value       = aws_efs_file_system.mongodb_efs.id
}

output "efs_mount_target_ids" {
  description = "List of EFS mount target IDs"
  value       = [aws_efs_mount_target.efs_private01.id, aws_efs_mount_target.efs_private02.id]
}

