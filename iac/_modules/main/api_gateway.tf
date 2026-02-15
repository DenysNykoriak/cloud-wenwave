resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.app_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.allow_local_development ? [
      local.dashboard_cloudfront_url,
      "http://localhost:3000",
      ] : [
      local.dashboard_cloudfront_url,
    ]
    allow_methods     = ["GET", "OPTIONS", "POST", "PUT", "DELETE", "PATCH", "HEAD"]
    allow_headers     = ["Content-Type", "Authorization"]
    allow_credentials = false
    max_age           = 300
  }
}

resource "aws_apigatewayv2_stage" "api_gateway_default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.app_name}-cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.dashboard_user_pool_client.id]
    issuer   = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.dashboard_user_pool.id}"
  }
}

resource "aws_apigatewayv2_integration" "me_lambda" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = module.server-generated-lambdas.me_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "me" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /me"
  target    = "integrations/${aws_apigatewayv2_integration.me_lambda.id}"

  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"
}

output "api_gateway_url" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}
