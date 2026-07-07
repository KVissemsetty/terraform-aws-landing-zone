variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "bastion_security_group_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "tags" {
  type    = map(string)
  default = {}
}
