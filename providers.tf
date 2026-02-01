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
}