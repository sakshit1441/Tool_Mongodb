##########################################
# Fetch My Public IP dynamically
##########################################
data "http" "my_ip" {
  url = "https://api.ipify.org"
}

##########################################
# MODULE: NETWORKING
##########################################
module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

##########################################
# MODULE: COMPUTE
##########################################
module "compute" {
  source = "./modules/compute"

  # EC2
  mongo_ami           = var.mongo_ami
  mongo_instance_type = var.mongo_instance_type
  key_name            = var.key_name

  # Networking
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets

  # Bastion SSH IP
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}

##########################################
# GENERATE ANSIBLE INVENTORY FILE
##########################################
resource "local_file" "ansible_inventory" {

  content = <<EOT
[mongodb]
%{ for ip in module.compute.mongo_private_ips ~}
${ip} ansible_user=ubuntu ansible_ssh_common_args='-o ProxyJump=ubuntu@${module.compute.bastion_public_ip}'
%{ endfor ~}
EOT

  filename = "${path.module}/../Ansible/inventory.ini"
}

