terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source  = "abbeylabs/abbey"
      version = " ~> 0.2.6"
    }

    aws = {
      source  = "hashicorp/aws"
      version = " ~> 5.24.0"
    }
  }
}

provider "abbey" {
  bearer_auth = var.abbey_token
}

provider "aws" {
  region = "us-east-1"
}