terraform {
  backend "s3" {
    bucket         = "${var.project_name}-${var.environment}-tf-state-12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}