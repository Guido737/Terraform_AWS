resource "aws_instance" "node" {
  count                  = 3
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
  ebs_optimized          = false
  tags = {
    Name  = "Nomad Linux Node-${count.index + 1}"
    Owner = "Creator Eversor"
  }
}



resource "aws_instance" "node2" {
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
  ebs_optimized          = false
  tags = {
    Name  = "Nomad Linux Node-2"
    Owner = "Creator Eversor"
  }
}


resource "aws_instance" "node3" {
  ami                    = "ami-0a72753edf3e631b7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
  ebs_optimized          = false
  tags = {
    Name  = "Nomad Linux Node-3"
    Owner = "Creator Eversor"
  }
}


resource "aws_security_group" "nomad" {
  description = "default VPC security group"
  ingress {
    from_port   = 0
    to_port     = 65535
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
    Name  = "Nomad Cluster"
    Owner = "Creator Eversor"
  }
}
