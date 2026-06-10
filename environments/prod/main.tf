module "vpc" {
  source = "../../modules/vpc"

  project_name = "aws-prod-infra"
  environment  = "prod"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}


module "security_groups" {
  source = "../../modules/security-groups"

  project_name = "aws-prod-infra"
  environment  = "prod"

  vpc_id = module.vpc.vpc_id

  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# IAM Roles, Policies, and Instance Profiles would be defined here as needed for EC2 instances and other resources.

module "iam" {
  source = "../../modules/iam"

  project_name = "aws-prod-infra"
  environment  = "prod"
}