# Generates a random password for the RDS instance

resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+"
}

# stores the generated password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db" {
  name = "${var.project_name}-${var.environment}-db-secret"

  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }
}

# secrete value for the RDS instance
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

# db subnet group

resource "aws_db_subnet_group" "this" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# Postgresql RDS instance

resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  deletion_protection = true

  skip_final_snapshot = false

  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot"

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  enabled_cloudwatch_logs_exports = [
    "postgresql"
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}