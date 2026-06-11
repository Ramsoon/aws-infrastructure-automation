terraform {
  backend "s3" {
    bucket         = "aws-prod-infra-prod-tf-state-150845"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}