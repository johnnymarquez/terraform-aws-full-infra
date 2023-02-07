module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.alb.name

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  security_groups = [module.security_group_alb.security_group_id]
  subnets         = module.vpc.public_subnets

  http_tcp_listeners = [
    {
      port         = var.alb.http_tcp_listeners.port
      protocol     = var.alb.http_tcp_listeners.protocol
      target_group = var.alb.http_tcp_listeners.target_group
      action_type  = var.alb.http_tcp_listeners.action_type
    }
  ]

  target_groups = [
    {
      name_prefix          = var.alb.target_groups.name_prefix
      backend_protocol     = var.alb.target_groups.backend_protocol
      backend_port         = var.alb.target_groups.backend_port
      target_type          = var.alb.target_groups.target_type
      deregistration_delay = var.alb.target_groups.deregistration_delay
      health_check         = {
        enabled             = var.alb.target_groups.health_check.enabled
        interval            = var.alb.target_groups.health_check.interval
        path                = var.alb.target_groups.health_check.path
        port                = var.alb.target_groups.health_check.port
        healthy_threshold   = var.alb.target_groups.health_check.healthy_threshold
        unhealthy_threshold = var.alb.target_groups.health_check.unhealthy_threshold
        timeout             = var.alb.target_groups.health_check.timeout
        protocol            = var.alb.target_groups.health_check.protocol
        matcher             = var.alb.target_groups.health_check.matcher
      }
      protocol_version = var.alb.target_groups.protocol_version
      targets          = {
        ec2_public_1 = {
          target_id = module.ec2_public_1.id
          port      = var.alb.target_groups.targets.port
        },
        ec2_public_2 = {
          target_id = module.ec2_public_2.id
          port      = var.alb.target_groups.targets.port
        }
      }
      tags = local.tags
    }
  ]

  tags = local.tags
}
