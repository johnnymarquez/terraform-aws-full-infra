module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc.name
  cidr = var.vpc.cidr

  azs             = var.vpc.azs
  public_subnets  = var.vpc.public_subnets
  private_subnets = var.vpc.private_subnets

  enable_nat_gateway = var.vpc.enable_nat_gateway
  enable_vpn_gateway = var.vpc.enable_vpn_gateway

  tags = local.tags
}
