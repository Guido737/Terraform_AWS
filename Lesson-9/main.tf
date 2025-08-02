#------------------------------------------------------
# My Terraform
#
# Finde Latest AMI id of:
#      - Ububtu 22.04
#      - Amazon Linux
#      - Windows Server Base
#
# Made By Creator/Eversor
#------------------------------------------------------


provider "aws" {
  region = "ap-southeast-2"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


data "aws_ami" "Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

}

data "aws_ami" "latest_windows" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }
}

resource "aws_instance" "my_ubuntu_webserver" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id

}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name

}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.Amazon_Linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.Amazon_Linux.name
}

output "latest_windows_ami_id" {
  value = data.aws_ami.latest_windows.id
}

output "latest_windows_ami_name" {
  value = data.aws_ami.latest_windows.name
}
