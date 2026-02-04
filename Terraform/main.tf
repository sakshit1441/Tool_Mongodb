##########################################################
# MODULE: Networking
# Creates VPC, Public/Private subnets, IGW, NAT, Route Tables
##########################################################
module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

##########################################################
# MODULE: Compute
# Creates MongoDB EC2 instances in private subnets
# Creates Security Group and EFS file system with mount targets
##########################################################
module "compute" {
  source               = "./modules/compute"
  mongo_ami            = var.mongo_ami
  mongo_instance_type  = var.mongo_instance_type
  key_name             = var.key_name
  vpc_id               = module.networking.vpc_id           
  private_subnets      = module.networking.private_subnets  
}

