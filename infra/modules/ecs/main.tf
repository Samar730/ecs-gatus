# Create ECS Cluster (Environment)
resource "aws_ecs_cluster" "cluster" {
    name = "${var.project_name}-cluster"

    setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Task Definition 
resource "aws_ecs_task_definition" "task_definition" {
    family = "${var.project_name}-task"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = var.task_cpu
    memory                   = var.task_memory
    execution_role_arn       = var.task_execution_role_arn

      container_definitions = jsonencode([
    {
      name      = var.container_definition_name
      image     = var.container_definition_image
      cpu       = var.container_definition_cpu
      memory    = var.container_definition_memory
      essential = true

      environment = [
  {
    name  = "VARIABLE_NAME"
    value = "variable_value"
  }
]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    },
      ]
    )
}
