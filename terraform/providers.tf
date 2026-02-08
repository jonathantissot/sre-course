terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "= 3.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.8.1"
    }
  }
}

provider "aws" {
  profile = "fet-aws"
  region  = "us-east-1"
  default_tags {
    tags = {
      Owner       = "foreachtoil"
      Environment = "sre-course"
      ManagedBy   = "Terraform"
    }
  }
}