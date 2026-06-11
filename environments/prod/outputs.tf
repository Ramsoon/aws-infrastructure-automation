# Networking

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Load Balancer

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.alb_arn
}

# Auto Scaling Group

output "asg_name" {
  description = "Auto Scaling Group Name"
  value       = module.ec2.asg_name
}

# Database

output "db_endpoint" {
  description = "PostgreSQL Endpoint"
  value       = module.rds.db_endpoint
}

output "db_identifier" {
  description = "Database Identifier"
  value       = module.rds.db_identifier
}


# Secrets Manager

output "db_secret_arn" {
  description = "Database Secret ARN"
  value       = module.rds.secret_arn

  sensitive = true
}

# Networking





output "alb_logs_bucket" {
  description = "ALB Logs Bucket"
  value       = module.s3.alb_logs_bucket
}

# Monitoring

output "cloudwatch_dashboard" {
  description = "CloudWatch Dashboard"
  value       = module.cloudwatch.dashboard_name
}

output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = module.sns.sns_topic_arn
}