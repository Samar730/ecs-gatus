output "alb_sg_id" {
  description = "ID of ALB Security Group"
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
    description = "ID of ECS Security Group"
    value = aws_security_group.ecs_sg.id
}