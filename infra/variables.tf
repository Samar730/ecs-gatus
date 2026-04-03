variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "project_name" {
  type        = string
  description = "Name of project, will be implemented when using tags"
  default     = "ecs-gatus"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  type    = string
  default = "10.0.3.0/24"
}
variable "private_subnet_b_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "az_1" {
  type    = string
  default = "eu-west-2a"
}

variable "az_2" {
  type    = string
  default = "eu-west-2b"
}

variable "internet_cidr" {
  type        = string
  description = "CIDR Block for Internet route"
  default     = "0.0.0.0/0"
}

variable "load_balancer_type" {
  type        = string
  description = "Describing the type of load balancer"
  default     = "application"
}

variable "subdomain_name" {
  type        = string
  description = "Subdomain name used for project"
  default     = "status.cloudbysamar.com"
}

variable "zone_name" {
  type    = string
  default = "cloudbysamar.com"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "container_definition_name" {
  type    = string
  default = "gatus"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "container_definition_cpu" {
  type    = number
  default = 256
}

variable "container_definition_memory" {
  type    = number
  default = 512
}

variable "retention_in_days" {
  type    = number
  default = 7
}

variable "desired_count" {
  type    = number
  default = 2
}