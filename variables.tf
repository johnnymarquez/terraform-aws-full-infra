variable "aws" {
  description = "aws provider variables"
  type        = object({
    region = string
  })
}

variable "vpc" {
  description = "Holds values for configuration of our VPC"
  type        = object({
    name               = string
    cidr               = string
    azs                = list(string)
    private_subnets    = list(string)
    public_subnets     = list(string)
    enable_nat_gateway = bool
    enable_vpn_gateway = bool
  })
}

variable "ec2" {
  description = "EC2 instances values"
  type        = object({
    name                        = string
    instance_type               = string
    key_name                    = string
    associate_public_ip_address = bool
    user_data                   = string
  })
}

variable "alb" {
  description = "Application Load Balancer specifications"
  type        = object({
    name               = string
    http_tcp_listeners = object({
      port         = number
      protocol     = string
      target_group = number
      action_type  = string
    })
    target_groups = object({
      name_prefix          = string
      backend_protocol     = string
      backend_port         = number
      target_type          = string
      deregistration_delay = number
      health_check         = object({
        enabled             = bool
        interval            = number
        path                = string
        port                = string
        healthy_threshold   = number
        unhealthy_threshold = number
        timeout             = number
        protocol            = string
        matcher             = string
      })
      protocol_version = string
      targets          = object({
        port = number
      })
    })
  })
}

variable "s3" {
  description = "S3 Bucket specifications"
  type        = object({
    bucket = string
    acl    = string
  })
}

