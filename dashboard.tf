resource "aws_s3_bucket" "dashboard" {
  bucket        = "${local.app_name}-dashboard"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "dashboard" {
  bucket = aws_s3_bucket.dashboard.id
  policy = data.aws_iam_policy_document.dashboard_policy_document.json
}

data "aws_iam_policy_document" "dashboard_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dashboard.arn}/*"]
  }
}

resource "aws_cloudfront_origin_access_control" "dashboard_origin_access_control" {
  name                              = "${local.app_name}-dashboard-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "dashboard" {
  origin {
    origin_access_control_id = aws_cloudfront_origin_access_control.dashboard_origin_access_control.id
    origin_id                = aws_s3_bucket.dashboard.id
    domain_name              = aws_s3_bucket.dashboard.bucket_regional_domain_name
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

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    target_origin_id       = aws_s3_bucket.dashboard.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}
