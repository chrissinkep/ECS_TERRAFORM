provider "aws" {
  region  = "us-east-1"
  version = "~> 5.0"
}


terraform {
  backend "s3" {
    bucket = "chrissinkep-terraform-remote-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}