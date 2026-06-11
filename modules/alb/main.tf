# Application Load Balancer

resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = var.alb_logs_bucket
    prefix  = "alb"
    enabled = true
  }

  # depends_on = [ aws_s3_bucket_policy.alb_logs ]

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# Target group for ALB

resource "aws_lb_target_group" "this" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}

# HTTP Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn
  }
}
