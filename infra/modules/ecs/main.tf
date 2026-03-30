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
      readonlyRootFilesystem = true

      environment = [
  {
    name  = "GATUS_CONFIG_PATH"
    value = "/config/config.yaml"
  }
]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
         "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
         "awslogs-region"        = var.aws_region
         "awslogs-stream-prefix" = "ecs"
         }
      }
    }
  ])
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "ecs_logs" {
    name = "${var.project_name}-logs"
    retention_in_days = var.retention_in_days
}

# ECS Service to manage Tasks
resource "aws_ecs_service" "ecs_service" {
    name = "${var.project_name}-service"
    cluster = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count = var.desired_count
    launch_type = "FARGATE"

    network_configuration {
      subnets = var.private_subnet_ids
      security_groups = [ var.ecs_sg ]
      assign_public_ip = false
    }
    
    load_balancer {
      target_group_arn = var.target_group_arn
      container_name   = var.container_definition_name
      container_port   = 8080
    }
}