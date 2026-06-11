# sns topic

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Name        = "${var.project_name}-${var.environment}-alerts"
    Environment = var.environment
  }
}

# sns topic subscription

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"
  endpoint = var.alert_email
}

