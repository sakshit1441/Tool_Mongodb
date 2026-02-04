variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for MongoDB instances"
  type        = list(string)
}

variable "mongo_ami" {
  description = "AMI ID for MongoDB EC2 instances"
  type        = string
}

variable "mongo_instance_type" {
  description = "EC2 instance type for MongoDB"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

