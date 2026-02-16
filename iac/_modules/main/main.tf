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

data "aws_region" "current" {}

module "server-generated-lambdas" {
  source = "../server-generated-lambdas"

  app_name                     = var.app_name
  aws_iam_role_lambda_exec_arn = aws_iam_role.lambda_exec.arn
  lambda_env = {
    "LAMBDA_DASHBOARD_ACTIVITY_TOPIC_ARN" = aws_sns_topic.dashboard_activity.arn
  }
}
