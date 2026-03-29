variable "project_name" {
    type = string
    default = "ecs-gatus"
}

variable "subdomain_name" {
    type = string
    description = "Subdomain name used for project"
    default = "status.cloudbysamar.com"
}

variable "zone_name" {
    type = string
    default = "cloudbysamar.com"
}