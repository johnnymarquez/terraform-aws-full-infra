aws = {
  region = "us-west-2"
}

vpc = {
  name               = "development"
  azs                = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cidr               = "10.10.10.0/24"
  public_subnets     = ["10.10.10.0/26", "10.10.10.64/26"]
  private_subnets    = ["10.10.10.128/25"]
  enable_nat_gateway = true
  enable_vpn_gateway = false
}

ec2 = {
  name                        = "web-instance"
  instance_type               = "t2.small"
  key_name                    = "key"
  associate_public_ip_address = true
  user_data                   = <<-EOF
#!/bin/bash
sudo -i
apt-get update &&
apt-get install -y nginx &&
echo '<html><body><h1>Healthy</h1></body></html>' > /var/www/html/status.html &&
systemctl restart nginx
EOF
}

alb = {
  name               = "web-alb"
  http_tcp_listeners = {
    port         = 80
    protocol     = "HTTP"
    target_group = 0
    action_type  = "forward"
  }
  target_groups = {
    name_prefix          = "h1"
    backend_protocol     = "HTTP"
    backend_port         = 80
    target_type          = "instance"
    deregistration_delay = 10
    health_check         = {
      enabled             = true
      interval            = 30
      path                = "/status.html"
      port                = "traffic-port"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 6
      protocol            = "HTTP"
      matcher             = "200-399"
    }
    protocol_version = "HTTP1"
    targets          = {
      port = 80
    }
  }
}

s3 = {
  bucket = "terraform-backend-development-exercise"
  acl    = "private"
}