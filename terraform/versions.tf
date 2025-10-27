terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  # backend "s3" {
  #   bucket         = "YOUR-TF-STATE-BUCKET"
  #   key            = "network/vpc-2subnets.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "YOUR-TF-LOCK-TABLE"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.region
}
