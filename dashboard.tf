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
    target_origin_id       = aws_s3_bucket.dashboard.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}

resource "aws_s3_object" "dashboard_file" {
  for_each = fileset("dashboard/dist", "**/*")

  bucket       = aws_s3_bucket.dashboard.id
  key          = each.value
  source       = "dashboard/dist/${each.value}"
  etag         = filemd5("dashboard/dist/${each.value}")
  content_type = lookup(local.dashboard_content_types, try(regex("\\.[^.]+$", each.value), ""), "application/octet-stream")
}
