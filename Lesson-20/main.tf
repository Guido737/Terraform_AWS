#------------------------------------------------------------------------
# Main Terraform Configuration
#
# Terraform Loops: Count and For-Each Concepts
# IAM Users + EC2 Instances Deployment
#
# Made By Creator Eversor
#------------------------------------------------------------------------

#---------------------------
# AWS Provider Configuration
#---------------------------
provider "aws" {
  region = "eu-central-1"
}

#---------------------------
# Single IAM User Creation
#---------------------------
resource "aws_iam_user" "user1" {
  name = "Tadeush"
}

#---------------------------
# Multiple IAM Users via Count Loop
#---------------------------
resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#------------------------------------------------------------------------
# EC2 Instances
#------------------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0a72753edf3e631b7"
  instance_type = "t3.micro"
  tags = {
    Name = "Server Number: ${count.index + 1}"
  }
}

#------------------------------------------------------------------------

