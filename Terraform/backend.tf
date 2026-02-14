terraform {
  backend "s3" {
    bucket         = "sakshi-mongodb-tfstate"   # Your S3 bucket
    key            = "mongodb/terraform.tfstate" # Path inside bucket
    region         = "ap-south-1"               # AWS region
    dynamodb_table = "terraform-lock"           # DynamoDB table for locking
    encrypt        = true                        # Enable server-side encryption
  }
}
