# terraform-aws-landing-zone

A modular, secure-by-default AWS landing zone built with Terraform: VPC,
public/private subnets, a locked-down bastion host, a private app server,
and an S3 bucket — all provisioned as code with remote state.

## Problem statement

Manually clicking through the AWS console (or copy-pasting one-off CFT
templates) to stand up networking and a bastion doesn't scale and isn't
auditable. This repo shows the same landing zone built as reusable
Terraform modules, with state stored remotely so it can be safely run by
a team or a CI pipeline instead of from one person's laptop.

## Architecture

```
                     Internet
                        |
                 [Internet Gateway]
                        |
        ---------------------------------
        |                               |
   [Public Subnet AZ-a]           [Public Subnet AZ-b]
        |
   [Bastion Host]  <-- SSH only from allowed_ssh_cidrs
        |
        | SSH (via bastion SG only)
        v
   [Private Subnet AZ-a] -- [App EC2 instance]
        |
   [NAT Gateway] -- outbound internet for private subnet

   [S3 Bucket] -- app data, public access blocked
```

## Stack

- Terraform >= 1.5
- AWS provider ~> 5.0
- Modules: `vpc`, `bastion`, `ec2-app`
- Remote state: S3 + DynamoDB lock (see `backend.tf`)

## How to run this

```bash
git clone <this-repo-url>
cd terraform-aws-landing-zone
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set your key_name and your IP in allowed_ssh_cidrs

terraform init
terraform plan
terraform apply
```

Prerequisites: Terraform >= 1.5, an AWS account, AWS CLI configured with
credentials that can create VPC/EC2/S3/IAM resources, and an existing EC2
key pair in the target region.

To reach the private app server:

```bash
ssh -i your-key.pem ec2-user@$(terraform output -raw bastion_public_ip)
# from inside the bastion:
ssh ec2-user@<app_server_private_ip>
```

## Cost & cleanup

Main cost drivers: one NAT gateway (~$0.045/hr + data processing) and two
t3.micro instances (free-tier eligible in most accounts). Estimated cost if
left running: well under $2/day.

```bash
terraform destroy
```

## What I'd change at production scale

- One NAT gateway per AZ instead of a single shared one, for AZ-level
  resilience
- Replace the SSH bastion with AWS Systems Manager Session Manager to
  remove the public SSH attack surface entirely
- Add an ALB + target group in front of the app tier instead of a single
  EC2 instance, plus an Auto Scaling Group
- Add AWS Config / GuardDuty for continuous compliance and threat detection
- Split this into separate Terraform state per environment (dev/stage/prod)
  rather than one `environment` variable toggling a single state file

## Screenshots

_(Add screenshots of `terraform apply` output and the resulting VPC in the
AWS console here.)_
