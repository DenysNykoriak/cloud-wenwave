terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "aws-saas-terraform-state"
    key          = "aws-saas.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}

locals {
  app_name = "aws-saas"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${local.app_name}-terraform-state"
  force_destroy = true
}
