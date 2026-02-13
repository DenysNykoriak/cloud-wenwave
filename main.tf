terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "cloud-wenwave-terraform-state"
    key          = "cloud-wenwave.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}



provider "aws" {
  region = "eu-central-1"
}

//! DO NOT CHANGE
resource "aws_kms_key" "terraform_state_key" {
  description             = "This key is used to encrypt terraform state bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "cloud-wenwave-terraform-state"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
// ------

locals {
  app_name = "cloud-wenwave"
}

locals {
  dashboard_content_types = {
    ".html"  = "text/html"
    ".js"    = "application/javascript"
    ".css"   = "text/css"
    ".json"  = "application/json"
    ".ico"   = "image/x-icon"
    ".svg"   = "image/svg+xml"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
  }
}
