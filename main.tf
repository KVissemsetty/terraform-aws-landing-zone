terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
    Environment = var.environment
  }
}

module "vpc" {
  source = "./modules/vpc"

  name                 = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.common_tags
}

module "bastion" {
  source = "./modules/bastion"

  name              = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  key_name          = var.key_name
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  tags              = local.common_tags
}

module "app_server" {
  source = "./modules/ec2-app"

  name                      = var.project_name
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr                  = var.vpc_cidr
  private_subnet_id         = module.vpc.private_subnet_ids[0]
  bastion_security_group_id = module.bastion.bastion_security_group_id
  key_name                  = var.key_name
  tags                      = local.common_tags
}

# S3 bucket for app artifacts/logs — demonstrates S3 + least-privilege IAM
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-app-data-${data.aws_caller_identity.current.account_id}"
  tags   = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket                  = aws_s3_bucket.app_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}
