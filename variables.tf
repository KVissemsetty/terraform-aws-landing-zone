variable "project_name" {
  description = "Short project name used as a prefix for all resources"
  type        = string
  default     = "sre-landing-zone"
}

variable "environment" {
  description = "Environment name (demo, dev, staging, prod)"
  type        = string
  default     = "demo"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in your AWS account"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "Your IP in CIDR form, e.g. [\"203.0.113.10/32\"] — never use 0.0.0.0/0"
  type        = list(string)
}
