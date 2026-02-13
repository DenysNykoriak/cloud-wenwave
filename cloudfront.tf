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
