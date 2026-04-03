module "vpc" {
  source = "./modules/vpc"

  cidr_block            = var.cidr_block
  project_name          = var.project_name
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  az_1                  = var.az_1
  az_2                  = var.az_2
  internet_cidr         = var.internet_cidr
}

module "sg" {
  source       = "./modules/sg"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "acm" {
  source         = "./modules/acm"
  project_name   = var.project_name
  subdomain_name = var.subdomain_name
  zone_name      = var.zone_name
}

module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  load_balancer_type = var.load_balancer_type
  alb_sg_id          = module.sg.alb_sg_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  certificate_arn    = module.acm.certificate_arn
}

module "route53" {
  source         = "./modules/route53"
  zone_name      = var.zone_name
  subdomain_name = var.subdomain_name
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}

module "ecs" {
  source                      = "./modules/ecs"
  project_name                = var.project_name
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  task_execution_role_arn     = module.iam.ecs_task_execution_role_arn
  container_definition_name   = var.container_definition_name
  image_tag                   = var.image_tag
  container_definition_cpu    = var.container_definition_cpu
  container_definition_memory = var.container_definition_memory
  retention_in_days           = var.retention_in_days
  aws_region                  = var.aws_region
  desired_count               = var.desired_count
  private_subnet_ids          = module.vpc.private_subnet_ids
  ecs_sg                      = module.sg.ecs_sg_id
  target_group_arn            = module.alb.target_group_arn
}