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


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0a72753edf3e631b7" #Amazon Linux Ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Creator",
    l_name = "Eversor",
    names  = ["Denis", "Arthur", "Bob", "Nick", "Anna", "Petrovich", "Megan"]
  })

  tags = {
    Name  = "Web Server Build by Terraform "
    Owner = "Creator Eversor"

  }


  # lifecycle {
  #   ignore_changes = ["ami", "user_data"]
  # }
  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First Sec Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
 
