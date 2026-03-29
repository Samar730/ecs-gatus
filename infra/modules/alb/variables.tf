variable "project_name" {
    type = string
    default = "ecs-gatus"
}

variable "load_balancer_type" {
    type = string
    description = "Describing the type of load balancer"
    default = "application"
}

variable "alb_sg_id" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
    description = "Attaching ALB in public subnets"
}

variable "vpc_id" {
    type = string
    description = "Attach target group to VPC"
}

variable "certificate_arn" {
    type = string
}