# ALB-SG Creation
resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
    description = "Security Group for ALB allowing inbound HTTP & HTPPS traffic"

    tags = {
      "Name" = "${var.project_name}-alb-sg"
    }
}

# Inbound/Outbound Rules for ALB-SG -> Allow HTTP & HTTPS traffic/ Outbound -> Internet
resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.alb_sg.id
    description = "Allow inbound HTTP (80) traffic" 

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80  
}

resource "aws_vpc_security_group_ingress_rule" "https" {
    security_group_id = aws_security_group.alb_sg.id
    description = "Allow inbound HTTPS (443) traffic"

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "egress_alb_all" {
    security_group_id = aws_security_group.alb_sg.id
    description = "Allow all outbound traffic"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"    
}

# ECS-SG Creation
resource "aws_security_group" "ecs_sg" {
    vpc_id = var.vpc_id
    description = "Security Group for ECS"

    tags = {
      "Name" = "${var.project_name}-ecs-sg"
    }
}

# Allow inbound traffic from ALB-SG on port 8080 (TCP)
resource "aws_vpc_security_group_ingress_rule" "ingress_from_alb" {
    security_group_id = aws_security_group.ecs_sg.id
    description = "Allow inbound traffic from ALB Security Group through port 8080"

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 8080
    ip_protocol = "tcp"
    to_port = 8080
    
    referenced_security_group_id =aws_security_group.alb_sg.id
}

resource "aws_vpc_security_group_egress_rule" "egress_ecs_all" {
    security_group_id = aws_security_group.ecs_sg.id
    description = "Allow all outbound traffic"

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}