#----------------------------------------------------------------------------
# My Terraform
#
# Terraform Conditions and Lookups
#
# Made By Creator Eversor
#----------------------------------------------------------------------------

#--------------------------------------------------
# AWS Provider configuration: specify region
#--------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

#--------------------------------------------------
# EC2 instance "my_webserver1"
# Conditional instance_type based on environment variable 'env'
#--------------------------------------------------
resource "aws_instance" "my_webserver1" {
  ami = "ami-0a72753edf3e631b7"
  // instance_type = (var.env == "prod" ? "t2.large" : "t2.mico")
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

#--------------------------------------------------
# EC2 instance "my_webserver2"
# Instance_type selected by lookup from map ec2_size using env key
#--------------------------------------------------
resource "aws_instance" "my_webserver2" {
  ami           = "ami-0a72753edf3e631b7"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

#--------------------------------------------------
# EC2 instance "my_dev_bastion"
# Created only if environment is 'dev', count = 1; otherwise 0 instances
#--------------------------------------------------
resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-0a72753edf3e631b7"
  instance_type = "t2.mico" # Возможно опечатка, должно быть "t2.micro"

  tags = {
    Name = "Bastion Server for Dev-server"
  }
}

#--------------------------------------------------
# Security group "my_webserver"
# Dynamic ingress rules created based on allowed ports for current environment
#--------------------------------------------------
resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"
  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Creator Eversor"
  }
}
