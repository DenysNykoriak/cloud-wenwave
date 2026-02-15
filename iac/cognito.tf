resource "aws_cognito_user_pool" "dashboard_user_pool" {
  name              = "${local.app_name}-dashboard-user-pool"
  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }

  lambda_config {
    pre_sign_up = module.server-generated-lambdas.pre-sign-up_lambda_arn
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "dashboard_user_pool_domain" {
  user_pool_id = aws_cognito_user_pool.dashboard_user_pool.id
  domain       = local.app_name
}

resource "aws_cognito_user_pool_client" "dashboard_user_pool_client" {
  user_pool_id = aws_cognito_user_pool.dashboard_user_pool.id
  name         = "${local.app_name}-dashboard-user-pool-client"
  callback_urls = [
    "https://${aws_cloudfront_distribution.dashboard_app_distribution.domain_name}",
    "http://localhost:3000",
  ]
  logout_urls = [
    "https://${aws_cloudfront_distribution.dashboard_app_distribution.domain_name}",
    "http://localhost:3000",
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

output "oidc_authority" {
  value = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.dashboard_user_pool.id}"
}

output "oidc_client_id" {
  value = aws_cognito_user_pool_client.dashboard_user_pool_client.id
}
