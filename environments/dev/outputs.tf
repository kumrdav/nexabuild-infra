output "instance_id" {
    description = "The EC2 instance ID"
    value = aws_instance.dev_server.id
}

output "public_ip" {
    description = "Publi IP address of the dev server"
    value = aws_instance.dev_server.public_ip
}

output "vpc_id" {
    description = "Default VPC ID being used"
    value = data.aws_vpc.default.id
}