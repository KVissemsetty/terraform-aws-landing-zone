output "bastion_public_ip" {
  description = "SSH into this to reach the private app server"
  value       = module.bastion.bastion_public_ip
}

output "app_server_private_ip" {
  value = module.app_server.app_private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data.bucket
}
