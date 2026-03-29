# Creating the identity for Task Execution Role 
resource "aws_iam_role" "task_execution_role" {
    name = "${var.project_name}-task-execution-role"
    description = "IAM role for ECS to pull images from ECR and write logs to CloudWatch"

     assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-task-execution-role"
  }
  }  

# Policy attachment block to link both the identity and policy
resource "aws_iam_role_policy_attachment" "task_execution_policy" {
    role = aws_iam_role.task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Role for the Gatus application
resource "aws_iam_role" "task_role" {
    name = "${var.project_name}-task-role"
    description = "Role attached for the Gatus application"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    "Name" = "${var.project_name}-task-role"
  }
    
}