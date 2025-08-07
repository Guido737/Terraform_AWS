#-----------------------------------------------------------------
# My Terraform
#
# Provision Resources in Multiple AWS / Accounts
#
# Made By Creator Eversor 
#-----------------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
  assume_role {
    # role_arn     = "arn:aws:iam:1234567890:role/RemoteAdministrator"
    # session_name = "TERRAFORM_SESSION"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "DEU"
}

#-----------------------------------------------------------------
# Creating Server in Canada
#-----------------------------------------------------------------
resource "aws_instance" "my_canada_server" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ca_latest_linux.id
  tags = {
    Name = "Canada Server"
  }
}

#-----------------------------------------------------------------
# Creating Server in USA
#-----------------------------------------------------------------
resource "aws_instance" "my_usa_server" {
  provider      = aws.USA
  instance_type = var.instance_type
  ami           = data.aws_ami.usa_latest_linux.id
  tags = {
    Name = "USA Server"
  }
}

#-----------------------------------------------------------------
# Creating Server in Frankfurt
#-----------------------------------------------------------------
resource "aws_instance" "my_deu_server" {
  provider      = aws.DEU
  instance_type = var.instance_type
  ami           = data.aws_ami.deu_latest_linux.id
  tags = {
    Name = "Deutschland Server"
  }
}
