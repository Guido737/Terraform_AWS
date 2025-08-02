#-----------------------------------------------------------
# Provision Highly Available Website in any Region (Default VPC)
# Create:
#    - Security Group for Web Server
#    - Launch Template with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#
# Made by Creator Eversor 02/08/25
#-----------------------------------------------------------

provider "aws" {
  region = "eu-west-2"
}

#------------------------------------------------------------------
# Data Sources

data "aws_availability_zones" "available" {}

data "aws_ami" "Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#------------------------------------------------------------------
# Security Group

resource "aws_security_group" "web" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
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
    Name  = "Dynamic SecurityGroup"
    Owner = "Creator Eversor"
  }
}

#------------------------------------------------------------------
# Launch Template

resource "aws_launch_template" "web" {
  // name         = "WEBServer-Highly-Available-LC"
  name_prefix   = "WEBServer-Highly-Available-LC"
  image_id      = data.aws_ami.Amazon_Linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "WebServer-From-LT"
      Owner = "Creator"
    }
  }
}

#------------------------------------------------------------------
# Classic Load Balancer

resource "aws_elb" "web" {
  name = "WebServer-HA-ELB"
  availability_zones = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
  security_groups = [aws_security_group.web.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name = "WEBServer-Highly-Available-ELB"
  }
}

#------------------------------------------------------------------
# Auto Scaling Group

resource "aws_autoscaling_group" "web" {
  name              = "ASG-${aws_launch_template.web.name}"
  min_size          = 2
  max_size          = 2
  min_elb_capacity  = 2
  health_check_type = "ELB"
  load_balancers    = [aws_elb.web.name]
  vpc_zone_identifier = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id
  ]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = {
      Name  = "WebServer-in-ASG"
      Owner = "Creator"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------------------
# Output

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
