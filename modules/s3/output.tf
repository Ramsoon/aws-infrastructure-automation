output "terraform_state_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_logs.bucket
}

output "alb_logs_bucket_arn" {
  value = aws_s3_bucket.alb_logs.arn
}