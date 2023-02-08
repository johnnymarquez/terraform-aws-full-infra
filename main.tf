terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  /*
  backend "s3" {
    bucket = "terraform-backend"
    key    = "key"
    region = "us-east-1"
  }*/
}
