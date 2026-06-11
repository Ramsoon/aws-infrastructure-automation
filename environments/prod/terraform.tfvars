# General

project_name = "aws-prod-infra"

environment = "prod"

aws_region = "us-east-1"

# Networking

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

# Security

allowed_ssh_cidr = "102.88.115.92/32"

# EC2

instance_type = "t3.micro"

# Database

db_name     = "appdb"
db_username = "dbadmin"

# Monitoring

alert_email = "sadiqabdulrahman00880@gmail.com"