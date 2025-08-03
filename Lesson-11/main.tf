#-----------------------------------------------------------
# Provision Blue/Green Deployment Web Cluster with Zero Downtime
#    - ALB with 2 Target Groups: Blue & Green
#    - 2 Launch Templates and ASGs for Blue/Green
#    - Listener Switch for Deployment
#
# Made by Creator Eversor 03/08/25
#-----------------------------------------------------------

provider "aws" {
  region = "eu-west-2"
}

#-----------------------------------------------------------
# Data Sources

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

#-----------------------------------------------------------
# Networking

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#-----------------------------------------------------------
# Security Group

resource "aws_security_group" "web" {
  name = "Web-SG"

  dynamic "ingress" {
    for_each = [80, 443]
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
    Name = "WebSG"
  }
}

#-----------------------------------------------------------
# ALB + Target Groups

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups    = [aws_security_group.web.id]
}

resource "aws_lb_target_group" "blue" {
  name     = "blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_subnet.default_az1.vpc_id
}

resource "aws_lb_target_group" "green" {
  name     = "green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_subnet.default_az1.vpc_id
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

#-----------------------------------------------------------
# Launch Templates

resource "aws_launch_template" "blue" {
  name_prefix   = "web-blue-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-blue-instance"
    }
  }
}

resource "aws_launch_template" "green" {
  name_prefix   = "web-green-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-green-instance"
    }
  }
}

#-----------------------------------------------------------
# Auto Scaling Groups

resource "aws_autoscaling_group" "blue" {
  name                = "blue-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns   = [aws_lb_target_group.blue.arn]
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Blue-ASG"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name                = "green-asg"
  min_size            = 0
  max_size            = 2
  desired_capacity    = 0
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns   = [aws_lb_target_group.green.arn]
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Green-ASG"
    propagate_at_launch = true
  }
}

#-----------------------------------------------------------
# Outputs

output "alb_dns" {
  value = aws_lb.web_alb.dns_name
}
