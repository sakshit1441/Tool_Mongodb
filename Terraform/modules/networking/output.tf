##########################################################
# VPC OUTPUTS
##########################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.mongo_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.mongo_vpc.cidr_block
}

##########################################################
# SUBNET OUTPUTS
##########################################################

output "public_subnet_id" {
  description = "Public subnet ID for Bastion host"
  value       = aws_subnet.public[0].id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

##########################################################
# NAT GATEWAY OUTPUT (OPTIONAL)
##########################################################

output "nat_gateway_id" {
  description = "NAT Gateway ID (for debugging)"
  value       = aws_nat_gateway.nat.id
}
