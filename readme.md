# AWS Production-Ready Infrastructure Automation

## Project Overview

This project demonstrates the design, provisioning, and automation of a production-ready AWS infrastructure using Terraform and GitHub Actions. The infrastructure follows Infrastructure as Code (IaC) best practices and incorporates scalable, secure, and highly available AWS services commonly used in modern cloud environments.

The entire infrastructure can be provisioned and destroyed automatically through GitHub Actions using OpenID Connect (OIDC) authentication, eliminating the need for long-lived AWS access keys.

---

## Project Description

Designed and automated a production-ready AWS environment using Terraform and GitHub Actions, implementing scalable compute, secure networking, managed databases, monitoring, alerting, and Infrastructure as Code best practices.

---

## Architecture

### Networking
- Virtual Private Cloud (VPC)
- Public Subnets across multiple Availability Zones
- Private Subnets across multiple Availability Zones
- Internet Gateway
- NAT Gateway
- Route Tables

### Compute
- EC2 Launch Template
- Auto Scaling Group
- Application Load Balancer (ALB)

### Database
- Amazon RDS PostgreSQL
- Secrets Manager integration for database credentials

### Storage
- Amazon S3
  - ALB Access Logs
  - Terraform Remote State Storage

### Monitoring & Alerting
- Amazon CloudWatch
- CloudWatch Alarms
- Amazon SNS Notifications

### Security
- IAM Roles and Policies
- Security Groups
- AWS Secrets Manager
- OIDC Authentication for GitHub Actions

### Automation
- Terraform
- GitHub Actions CI/CD

---

## Architecture Diagram

```text
                          Internet
                              │
                              ▼
                   ┌──────────────────┐
                   │ Application Load │
                   │    Balancer      │
                   └──────────────────┘
                              │
                              ▼
                   ┌──────────────────┐
                   │ Auto Scaling     │
                   │ Group (EC2)      │
                   └──────────────────┘
                              │
                ┌─────────────┴─────────────┐
                ▼                           ▼

         Private Subnet A           Private Subnet B

                └─────────────┬─────────────┘
                              ▼

                    Amazon RDS PostgreSQL

                              │
                              ▼

                 Secrets Manager Storage

                              │
                              ▼

                 CloudWatch + SNS Alerts
```

---

# Production-Ready Features Implemented

## Infrastructure as Code

All infrastructure is provisioned and managed using Terraform.

Benefits:

- Version controlled infrastructure
- Reproducible deployments
- Consistent environments
- Automated provisioning

---

## Remote Terraform State

Terraform state is stored remotely in Amazon S3.

Benefits:

- Centralized state management
- Team collaboration support
- State persistence
- Disaster recovery

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "aws-prod-infra-prod-tf-state-150845"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

## Auto Scaling

The infrastructure uses an Auto Scaling Group for EC2 instances.

Benefits:

- High availability
- Self-healing infrastructure
- Elastic scaling
- Reduced operational overhead

---

## Multi-AZ Deployment

Resources are deployed across multiple Availability Zones.

Benefits:

- Increased availability
- Fault tolerance
- Reduced downtime

---

## Application Load Balancer

The Application Load Balancer distributes traffic across EC2 instances.

Features:

- Health checks
- Traffic distribution
- Scalability
- ALB Access Logging

---

## Secure Secrets Management

Database credentials are stored in AWS Secrets Manager.

Benefits:

- No hardcoded passwords
- Centralized secret management
- Secure access control

---

## CloudWatch Monitoring

CloudWatch is used for infrastructure monitoring.

Monitored Components:

- EC2 CPU Utilization
- RDS Metrics
- Auto Scaling Events
- Load Balancer Metrics

Benefits:

- Operational visibility
- Proactive monitoring
- Performance insights

---

## SNS Alerting

CloudWatch alarms trigger SNS notifications.

Examples:

- High CPU Utilization
- Resource failures
- Infrastructure health alerts

---

## Security Best Practices

### Network Segmentation

- Public Subnets for ALB and NAT Gateway
- Private Subnets for EC2 and RDS

### Security Groups

Principle of least privilege:

- ALB accepts HTTP/HTTPS traffic
- EC2 accepts traffic only from ALB
- RDS accepts traffic only from EC2

### Secrets Management

- Database credentials stored in Secrets Manager
- No credentials committed to Git

---

# GitHub Actions CI/CD

Infrastructure deployments are fully automated using GitHub Actions.

## Workflow Features

### Pull Request Validation

On Pull Requests:

- Terraform Format Check
- Terraform Validation
- Terraform Plan

### Manual Infrastructure Deployment

Supports:

```text
Apply Infrastructure
Destroy Infrastructure
```

through GitHub Actions Workflow Dispatch.

### Destroy Protection

Destroy operations require explicit confirmation:

```text
DESTROY
```

to prevent accidental infrastructure deletion.

---

# GitHub Actions OIDC Authentication

## Why OIDC?

Traditional CI/CD pipelines often require storing AWS Access Keys in GitHub Secrets.

This project uses OIDC federation instead.

Benefits:

- No long-lived AWS credentials
- Short-lived temporary credentials
- Improved security posture
- AWS recommended authentication method

---

## OIDC Flow

```text
GitHub Actions
      │
      ▼

OIDC Token

      │
      ▼

AWS IAM Role

      │
      ▼

Temporary Credentials

      │
      ▼

Terraform Deployment
```

---

## IAM Trust Relationship

The GitHub Actions role trusts GitHub's OIDC provider.

Example:

```json
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
  },
  "Action": "sts:AssumeRoleWithWebIdentity"
}
```

---

# Repository Structure

```text
.
├── .github
│   └── workflows
│       └── terraform.yml
│
├── environments
│   └── prod
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│
├── modules
│   ├── alb
│   ├── cloudwatch
│   ├── ec2
│   ├── iam
│   ├── rds
│   ├── s3
│   ├── security-groups
│   ├── sns
│   └── vpc
│
└── README.md
```

---

# Deployment

## Clone Repository

```bash
git clone https://github.com/<username>/<repository>.git

cd <repository>
```

---

## Initialize Terraform

```bash
cd environments/prod

terraform init
```

---

## Validate Configuration

```bash
terraform validate
```

---

## Review Infrastructure Changes

```bash
terraform plan
```

---

## Deploy Infrastructure

```bash
terraform apply
```

---

## Destroy Infrastructure

```bash
terraform destroy
```

---

# GitHub Actions Deployment

## Apply

Navigate to:

```text
Actions
→ Terraform Infrastructure
→ Run Workflow
→ Apply
```

---

## Destroy

Navigate to:

```text
Actions
→ Terraform Infrastructure
→ Run Workflow
→ Destroy

Confirmation:
DESTROY
```

---

# Lessons Learned

During implementation, several real-world AWS challenges were encountered and resolved:

### ALB Access Logging

Issue:
- ALB log delivery failed with "Access Denied"

Root Cause:
- S3 bucket policy path did not match the configured ALB log prefix.

Resolution:
- Updated ALB logging configuration and S3 permissions to align with the actual log delivery path.

---

### RDS Snapshot Conflicts

Issue:
- Terraform destroy failed due to existing final snapshots.

Resolution:
- Implemented snapshot management strategy and cleanup procedures.

---

### S3 Bucket Deletion

Issue:
- Versioned S3 buckets could not be destroyed.

Resolution:
- Enabled `force_destroy = true` for automated cleanup during infrastructure destruction.

---

# Future Improvements

Planned enhancements include:

- HTTPS with ACM Certificates
- Route 53 DNS Integration
- AWS WAF
- CloudWatch Dashboards
- AWS Systems Manager (SSM)
- Blue/Green Deployments
- ECS Fargate Migration
- EKS Kubernetes Deployment
- Centralized Logging
- Security Hub Integration

---

# Technologies Used

- AWS
- Terraform
- GitHub Actions
- IAM
- OIDC
- EC2
- Auto Scaling
- Application Load Balancer
- RDS PostgreSQL
- S3
- CloudWatch
- SNS
- Secrets Manager

---

# Author

Sadiq Abdulrahaman

DevOps Engineer | Cloud Engineer | Linux Administrator
