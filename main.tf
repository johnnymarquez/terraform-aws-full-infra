terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  /*
  backend "s3" {
    bucket = "terraform-backend-development-exercise"
    key    = "key"
    region = "us-west-2"
  }*/
}
