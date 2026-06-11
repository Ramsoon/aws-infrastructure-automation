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

# S3 buckets for Terraform state and ALB logs

module "s3" {
  source = "../../modules/s3"

  project_name = "aws-prod-infra"
  environment  = "prod"
}

# Application Load Balancer
module "alb" {
  source = "../../modules/alb"

  project_name = "aws-prod-infra"
  environment  = "prod"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  alb_sg_id      = module.security_groups.alb_sg_id
  alb_logs_bucket = module.s3.alb_logs_bucket

  depends_on = [ module.s3 ]
}

# EC2 instances in Auto Scaling Group

module "ec2" {
  source = "../../modules/ec2"

  project_name = "aws-prod-infra"
  environment  = "prod"

  private_subnet_ids = module.vpc.private_subnet_ids

  ec2_sg_id = module.security_groups.ec2_sg_id

  instance_profile_name = module.iam.instance_profile_name

  target_group_arn = module.alb.target_group_arn

  instance_type = "t3.micro"
}

# RDS instance
module "rds" {
  source = "../../modules/rds"

  project_name = "aws-prod-infra"
  environment  = "prod"

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_sg_id = module.security_groups.rds_sg_id

  db_name     = "appdb"
  db_username = "dbadmin"
}

# SNS topic for alerts
module "sns" {
  source = "../../modules/sns"

  project_name = "aws-prod-infra"
  environment  = "prod"

  alert_email = "sadiqabdulrahman00880@gmail.com"
}

# CloudWatch Alarms for EC2, ALB, and RDS
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name = "aws-prod-infra"
  environment  = "prod"

  sns_topic_arn = module.sns.sns_topic_arn

  alb_arn_suffix = module.alb.alb_arn_suffix

  db_identifier = module.rds.db_identifier

  asg_name = module.ec2.asg_name
}