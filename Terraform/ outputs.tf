output "ec2_public_ip" {
  value = aws_instance.mongodb_ec2.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.mongodb_ec2.private_ip
}

output "security_group_id" {
  value = aws_security_group.mongo_sg.id
}
