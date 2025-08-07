#------------------------------------------------------------
# AWS Provider
#------------------------------------------------------------
provider "aws" {
  region = "ca-central-1"
}

#------------------------------------------------------------
# Terraform Remote Backend
#------------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    region = "us-east-1"
  }
}

#------------------------------------------------------------
# EC2 Instance
#------------------------------------------------------------
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = filebase64("user_data.sh")

  tags = {
    Name = "WebServer"
  }
}

#------------------------------------------------------------
# Security Group for EC2
#------------------------------------------------------------
resource "aws_security_group" "webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Creator Eversor"
  }
}
