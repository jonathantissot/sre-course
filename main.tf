module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "= 6.6.0"

  name = "test-vpc"
  cidr = var.vpc.cidr_block

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}

module "aws_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "= 21.15.1"

  name               = "test-eks"
  kubernetes_version = "1.34"

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
  # aws_vpc.main.id
  vpc_id     = module.aws_vpc.vpc_id
  subnet_ids = module.aws_vpc.private_subnets

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}