output "instance_id" {
    description = "The EC2 instance ID"
    value = aws_instance.dev_server.id
}

output "public_ip" {
    description = "Publi IP address of the dev server"
    value = aws_instance.dev_server.public_ip
}

output "vpc_id" {
  description = "VPC ID from VPC module"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}