output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnets
}

output "private_subnet_ids" {
  value = module.networking.private_subnets
}

output "mongo_instance_ids" {
  value = module.compute.mongo_instance_ids
}

output "efs_id" {
  value = module.compute.efs_id
}

