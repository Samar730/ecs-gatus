variable "zone_name" {
    type = string
    default = "cloudbysamar.com"
}

variable "subdomain_name" {
    type = string
    default = "status.cloudbysamar.com"
}

variable "alb_dns_name" {
    type = string
    description = "ALB DNS name for Route53 Alias record pointing"
}

variable "alb_zone_id" {
    type = string
    description = "Hosted zone ID of the ALB for Route53 Alias record"
}