#------------------------------------------------------------
# AWS Provider with default tags
#------------------------------------------------------------

provider "aws" {
  region = "ca-central-1"

  default_tags {
    tags = {
      Owner     = "Creator Eversor"
      CreatedBy = "Terraform"
      Course    = "From Zero to Certified Professional"
    }
  }
}

#------------------------------------------------------------
# Data sources for AZs and latest Amazon Linux 2023 AMI
#------------------------------------------------------------

data "aws_availability_zones" "working" {}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
}

#------------------------------------------------------------
# Default VPC and subnets in two availability zones
#------------------------------------------------------------

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}

#------------------------------------------------------------
# Security group for ALB and EC2 instances
#------------------------------------------------------------

resource "aws_security_group" "web" {
  name   = "Web Security Group"
  vpc_id = aws_default_vpc.default.id

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
    Name = "Web SecurityGroup"
  }
}

#------------------------------------------------------------
# Launch Template for EC2 Auto Scaling
#------------------------------------------------------------

resource "aws_launch_template" "web" {
  name                   = "WebServer-Highly-Available-LT"
  image_id               = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServer-Instance"
    }
  }
}

#------------------------------------------------------------
# Auto Scaling Group across two subnets
#------------------------------------------------------------

resource "aws_autoscaling_group" "web" {
  name              = "WebServer-Highly-Available-ASG-Ver-${aws_launch_template.web.latest_version}"
  min_size          = 2
  max_size          = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id
  ]
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  tag {
    key                 = "Name"
    value               = "WebServer-in-ASG-v${aws_launch_template.web.latest_version}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "DevOps"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------------
# Application Load Balancer (ALB)
#------------------------------------------------------------

resource "aws_lb" "web" {
  name               = "webserver-ha-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id
  ]
  idle_timeout               = 60
  internal                   = false
  enable_deletion_protection = false
}

#------------------------------------------------------------
# Target Group for the Auto Scaling Group
#------------------------------------------------------------

resource "aws_lb_target_group" "web" {
  name                 = "webserver-ha-tg"
  vpc_id               = aws_default_vpc.default.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10
  target_type          = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#------------------------------------------------------------
# Listener on port 80 forwarding to target group
#------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#------------------------------------------------------------
# Output the ALB DNS name
#------------------------------------------------------------

output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}
