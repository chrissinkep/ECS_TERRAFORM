provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "chrissinkep-terraform-remote-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}