module "ec2_public_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = "${var.ec2.name}-public-1"
  instance_type               = var.ec2.instance_type
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group_web.security_group_id]
  associate_public_ip_address = var.ec2.associate_public_ip_address
  key_name                    = aws_key_pair.key_pair.key_name
  user_data_base64            = base64encode(var.ec2.user_data)

  tags = local.tags
}

module "ec2_public_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = "${var.ec2.name}-public-2"
  instance_type               = var.ec2.instance_type
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = element(module.vpc.public_subnets, 1)
  vpc_security_group_ids      = [module.security_group_web.security_group_id]
  associate_public_ip_address = var.ec2.associate_public_ip_address
  key_name                    = aws_key_pair.key_pair.key_name
  user_data_base64            = base64encode(var.ec2.user_data)

  tags = local.tags
}

module "ec2_private" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${var.ec2.name}-private"
  instance_type          = var.ec2.instance_type
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group_private.security_group_id]
  key_name               = aws_key_pair.key_pair.key_name

  tags = local.tags
}

# Elastic IP Allocation

resource "aws_eip" "ec2_public_1_eip" {
  instance = module.ec2_public_1.id
}

resource "aws_eip" "ec2_public_2_eip" {
  instance = module.ec2_public_2.id
}

# Private Key generation

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.ec2.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

# Latest Ubuntu LTS ami

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Ubuntu
}
