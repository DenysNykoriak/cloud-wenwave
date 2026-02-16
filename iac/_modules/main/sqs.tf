resource "aws_sqs_queue" "dashboard_activity_queue" {
  name                       = "${var.app_name}-dashboard-activity-queue"
  redrive_policy              = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dashboard_activity_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "dashboard_activity_dlq" {
  name                  = "${var.app_name}-dashboard-activity-dlq"
}

resource "aws_sqs_queue_redrive_allow_policy" "dashboard_activity_dlq_redrive_allow_policy" {
  queue_url = aws_sqs_queue.dashboard_activity_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.dashboard_activity_queue.arn]
  })
}

resource "aws_lambda_event_source_mapping" "dashboard_activity_queue_lambda" {
  event_source_arn = aws_sqs_queue.dashboard_activity_queue.arn
  function_name    = module.server-generated-lambdas.log_log_auth_lambda_arn
}



