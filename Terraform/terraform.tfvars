##########################################
# AWS CONFIGURATION
##########################################

aws_region = "ap-south-1"

##########################################
# NETWORKING CONFIGURATION
##########################################

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

##########################################
# COMPUTE (MONGODB + BASTION)
##########################################

mongo_instance_type = "t3.micro"
mongo_ami           = "ami-0f58b397bc5c1f2e8"
key_name            = "mumbai"
