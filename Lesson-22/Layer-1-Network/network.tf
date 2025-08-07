#------------------------------------------------------------
# AWS Provider
#------------------------------------------------------------
provider "aws" {
  region = "ca-central-1"
}

#------------------------------------------------------------
# Terraform backend
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
resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnet_id
  tags = {
    Name = "Web-${var.env}"
  }
}
