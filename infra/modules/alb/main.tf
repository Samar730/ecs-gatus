# ALB Creation
resource "aws_alb" "alb" {
    name = "${var.project_name}-alb"
    internal           = false
    load_balancer_type = var.load_balancer_type
    security_groups    = [var.alb_sg_id]
    subnets            = var.public_subnet_ids

    enable_deletion_protection = false

    tags = {
      "Name" = "${var.project_name}-alb"
    }
}

# Target Group for ECS tasks
resource "aws_alb_target_group" "main" {
    name = "${var.project_name}-tg"
    port     = 8080
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "ip"

    health_check {
      path = "/health"
      protocol = "HTTP"
      matcher = "200"
    }

    tags = {
      "Name" = "${var.project_name}-tg"
    }
}

# HTTP & HTTPS Listeners
resource "aws_alb_listener" "http" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "redirect"

      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }   
}

resource "aws_alb_listener" "https" {
    load_balancer_arn = aws_alb.alb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn = var.certificate_arn

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.main.arn
    }
}