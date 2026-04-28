variable "aws_region" {
  description = "AWS region where resouces will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Ec2 instance type - determines CPU and memory"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = " Name tag applied to the EC2 instance"
  type        = string
  default     = "nexabuild-dev-server"
}