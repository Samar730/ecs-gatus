output "target_group_arn" {
  description = "ARN of Target Group for HTTPS forwarding"
  value = aws_alb_target_group.main.arn
}

output "alb_dns_name" {
    description = "Required for Alias record"
    value = aws_alb.alb.dns_name
}

output "alb_zone_id" {
    description = "Required for Alias record"
    value = aws_alb.alb.zone_id
}