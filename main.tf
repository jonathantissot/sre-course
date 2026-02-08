module "networking" {
  source = "./modules/networking"
  vpc = var.vpc
  environment = var.environment
}