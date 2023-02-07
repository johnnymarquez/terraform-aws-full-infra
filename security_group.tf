module "security_group_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "security-group-web"
  description = "Allows HTTP/S connections from anywhere and SSH connections from the VPC CIDR"

  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP connections"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS connections"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH connections from vpc cidr"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all egress traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "security_group_private" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "security-group-private"
  description = "Allow incoming connections the VPC CIDR"

  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH connections from vpc cidr"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "Connections from web instncaes"
      source_security_group_id = module.security_group_web.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all egress traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  ingress_rules = [
    "http-80-tcp", "all-icmp"
  ]
  egress_rules = [
    "all-all"
  ]
}