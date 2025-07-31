#------------------------------------------------
# My Terraform
#
# Build Webserver during Bootstrap
#
# Made by Creator 
#------------------------------------------------


provider "aws" {
  region = "eu-central-1"
}



resource "aws_instance" "my_server_web" {
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web-Server"
  }

  depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server-Application"
  }

  depends_on = [aws_instance.my_server_db]
}

resource "aws_instance" "my_server_db" {
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server-Database"
  }
}



resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
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

