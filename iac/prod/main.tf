terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "cloud-wenwave-terraform-state"
    key          = "prod/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  env_name   = "prod"
  aws_region = "eu-central-1"
}

module "main" {
  source                  = "../_modules/main"
  app_name                = "cloud-wenwave-${local.env_name}"
  aws_region              = local.aws_region
  allow_local_development = false
}

output "dashboard_cloudfront_url" {
  value = module.main.dashboard_cloudfront_url
}
output "oidc_authority" {
  value = module.main.oidc_authority
}
output "oidc_client_id" {
  value = module.main.oidc_client_id
}
output "api_gateway_url" {
  value = module.main.api_gateway_url
}
