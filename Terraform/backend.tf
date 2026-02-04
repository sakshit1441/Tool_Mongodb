terraform {
  backend "s3" {
    bucket         = "sakshi-mongodb-tfstate"
    key            = "mongodb/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
