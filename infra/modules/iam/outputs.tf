output "ecs_task_execution_role_arn" {
    description = "The ARN of the ecs task execution role (used for ecs module)"
    value = aws_iam_role.task_execution_role.arn
}

output "ecs_task_role_arn" {
    description = "ARN of task role"
    value = aws_iam_role.task_role.arn
}