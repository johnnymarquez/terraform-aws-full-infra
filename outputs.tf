output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_key" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}

output "latest_ubuntu_ami" {
  value = data.aws_ami.ubuntu
}
