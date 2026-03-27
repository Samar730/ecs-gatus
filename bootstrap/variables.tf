variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type        = string
  description = "Name of Project (ecs-gatus), other variables will be based around this specifically for bootstrapping"
  default     = "ecs-gatus"
}

variable "github_repo" {
  type        = string
  description = "ecs-gatus repo"
  default     = "Samar730/ecs-gatus"
}