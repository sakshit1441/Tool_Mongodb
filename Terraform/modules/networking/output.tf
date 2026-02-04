##########################################################
# Output VPC ID
##########################################################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.mongo_vpc.id
}

##########################################################
# Output Public Subnet IDs
##########################################################
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

##########################################################
# Output Private Subnet IDs
##########################################################
output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

##########################################################
# Output NAT Gateway ID (optional, useful for debugging)
##########################################################
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}
