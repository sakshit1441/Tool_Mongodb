output "mongo_instance_ids" {
  value = aws_instance.mongo[*].id
}

output "efs_id" {
  value = aws_efs_file_system.mongo_efs.id
}

