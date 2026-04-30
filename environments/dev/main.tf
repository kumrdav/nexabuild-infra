terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nexabuild-terraform-state-kumar"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nexabuild-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "nexabuild"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "dev_sg" {
  name        = "nexabuild-dev-sg"
  description = "Security group for dev server"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "nexabuild-dev-sg"
  }
}

resource "aws_instance" "dev_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tags = {
    Name = var.instance_name
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  environment = "dev"
}