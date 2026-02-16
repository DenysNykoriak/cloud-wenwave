resource "aws_sns_topic" "dashboard_activity" {
  name = "${var.app_name}-dashboard-activity"
}

resource "aws_sns_topic_subscription" "dashboard_activity_queue" {
  topic_arn = aws_sns_topic.dashboard_activity.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.dashboard_activity_queue.arn
}