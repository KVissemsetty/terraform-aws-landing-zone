# Remote state — demonstrates proper state management instead of local .tfstate.
#
# Before first `terraform init`, create the S3 bucket + DynamoDB lock table
# ONCE, manually or via a tiny separate bootstrap config (don't manage the
# state backend's own storage with the same Terraform config that uses it):
#
#   aws s3api create-bucket --bucket my-tf-state-bucket --region us-east-1
#   aws s3api put-bucket-versioning --bucket my-tf-state-bucket \
#     --versioning-configuration Status=Enabled
#   aws dynamodb create-table --table-name terraform-locks \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST
#
# Then uncomment and fill in the block below.

# terraform {
#   backend "s3" {
#     bucket         = "my-tf-state-bucket"
#     key            = "sre-landing-zone/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
