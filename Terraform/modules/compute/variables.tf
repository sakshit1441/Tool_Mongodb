variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "mongo_ami" {
  type = string
}

variable "mongo_instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "my_ip" {
  type = string
}
