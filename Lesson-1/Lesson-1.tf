provider "aws" {}

resource "aws_instance" "my-Kali" {
  ami           = "ami-0a72753edf3e631b7"
  instance_type = "t3.micro"

  tags = {
    Name    = "My Linux Server"
    Owner   = "Creator Eversor"
    Project = "Terraform"
  }
}


resource "aws_instance" "my-Amazon" {
  ami           = "ami-0c1b03e30bca3b373"
  instance_type = "t3.small"
  tags = {
    Name    = "My Amazon Server"
    Owner   = "Creator Eversor"
    Project = "Terraform"
  }
}
