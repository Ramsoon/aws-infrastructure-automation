variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
}

############################################
# General
############################################

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

############################################
# Networking
############################################

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

############################################
# Security
############################################

variable "allowed_ssh_cidr" {
  description = "Allowed SSH CIDR"
  type        = string
  default     = "0.0.0.0/32"
}

############################################
# EC2
############################################

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

############################################
# Database
############################################

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database admin username"
  type        = string
}

############################################
# Monitoring
############################################

variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
}