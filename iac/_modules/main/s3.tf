resource "aws_s3_bucket" "dashboard_app_bucket" {
  bucket        = "${var.app_name}-dashboard-app"
  force_destroy = true
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

resource "aws_s3_bucket_policy" "dashboard_app_bucket_policy" {
  bucket = aws_s3_bucket.dashboard_app_bucket.id
  policy = data.aws_iam_policy_document.dashboard_app_bucket_policy_document.json
}

# S3 Objects
resource "aws_s3_object" "dashboard_app_file" {
  for_each = fileset("../../dashboard/dist", "**/*")

  bucket       = aws_s3_bucket.dashboard_app_bucket.id
  key          = each.value
  source       = "../../dashboard/dist/${each.value}"
  etag         = filemd5("../../dashboard/dist/${each.value}")
  content_type = lookup(local.dashboard_content_types, try(regex("\\.[^.]+$", each.value), ""), "application/octet-stream")
}
