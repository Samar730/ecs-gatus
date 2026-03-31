variable "project_name" {
    type = string
    default = "ecs-gatus"
}

variable "task_cpu" {
    type = number
    default = 256
}

variable "task_memory" {
    type = number
    default = 512
}

variable "task_execution_role_arn" {
    type = string
}

variable "container_definition_name" {
    type = string
    default = "gatus"
}

variable "image_tag" {
    type = string
    default = "latest"
}

variable "container_definition_cpu" {
    type = number
    default = 256
}

variable "container_definition_memory" {
    type = number
    default = 512
}

variable "retention_in_days" {
    type = number
    default = 7
}

variable "aws_region" {
    type = string
    default = "eu-west-2"
}

variable "desired_count" {
    type = number
    default = 2
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "ecs_sg" {
    type = string
}

variable "target_group_arn" {
    type = string
}