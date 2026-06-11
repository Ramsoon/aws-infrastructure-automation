# cloudwatch dashboard

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.asg_name
            ]
          ]

          period = 300
          stat   = "Average"
          title  = "EC2 CPU Utilization"
          region = "us-east-1"
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.db_identifier
            ]
          ]

          period = 300
          stat   = "Average"
          title  = "RDS CPU Utilization"
          region = "us-east-1"
        }
      }
    ]
  })
}

# ec2/asg high cpu alarm

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 300
  statistic = "Average"

  threshold = 80

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

# rds high cpu alarm

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/RDS"

  period    = 300
  statistic = "Average"

  threshold = 80

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

# rds low strorage alarm

resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-storage-low"
  comparison_operator = "LessThanThreshold"

  evaluation_periods = 1

  metric_name = "FreeStorageSpace"
  namespace   = "AWS/RDS"

  period    = 300
  statistic = "Average"

  threshold = 2147483648

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

#  alb UNHEALTHY Target alarm

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-targets"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "UnHealthyHostCount"
  namespace   = "AWS/ApplicationELB"

  period    = 60
  statistic = "Average"

  threshold = 0

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}