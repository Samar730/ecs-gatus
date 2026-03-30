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

variable "container_definition_image" {
    type = string
}

variable "container_definition_cpu" {
    type = number
    default = 256
}

variable "container_definition_memory" {
    type = number
    default = 512
}

variable "env_key" {
    type = string
    default = "GATUS_CONFIG_PATH"
}

variable "env_value" {
    type = string
    default = "/config/config.yaml"
}