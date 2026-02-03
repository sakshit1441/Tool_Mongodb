variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  type    = string
}

variable "subnet_cidr" {
  type    = string
}

variable "ami_id" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "key_name" {
  type    = string
}
