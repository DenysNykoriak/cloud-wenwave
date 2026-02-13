resource "aws_s3_bucket" "dashboard_app_bucket" {
  bucket        = "${local.app_name}-dashboard-app"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "dashboard_app_bucket_policy" {
  bucket = aws_s3_bucket.dashboard_app_bucket.id
  policy = data.aws_iam_policy_document.dashboard_app_bucket_policy_document.json
}

data "aws_iam_policy_document" "dashboard_app_bucket_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dashboard_app_bucket.arn}/*"]
  }
}

resource "aws_cloudfront_origin_access_control" "dashboard_app_bucket_origin_access_control" {
  name                              = "${local.app_name}-dashboard-app-bucket-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "dashboard_app_distribution" {
  origin {
    origin_access_control_id = aws_cloudfront_origin_access_control.dashboard_app_bucket_origin_access_control.id
    origin_id                = aws_s3_bucket.dashboard_app_bucket.id
    domain_name              = aws_s3_bucket.dashboard_app_bucket.bucket_regional_domain_name
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    target_origin_id       = aws_s3_bucket.dashboard_app_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}

resource "aws_s3_object" "dashboard_app_file" {
  for_each = fileset("dashboard/dist", "**/*")

  bucket       = aws_s3_bucket.dashboard_app_bucket.id
  key          = each.value
  source       = "dashboard/dist/${each.value}"
  etag         = filemd5("dashboard/dist/${each.value}")
  content_type = lookup(local.dashboard_content_types, try(regex("\\.[^.]+$", each.value), ""), "application/octet-stream")
}

//Cognito
resource "aws_cognito_user_pool" "dashboard_user_pool" {
  name = "${local.app_name}-dashboard-user-pool"
  # mfa_configuration = "ON"

  # software_token_mfa_configuration {
  #   enabled = true
  # }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
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
