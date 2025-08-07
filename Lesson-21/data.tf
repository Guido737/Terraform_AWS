#-----------------------------------------------------------------
# AMI Lookups
#-----------------------------------------------------------------

data "aws_ami" "ca_latest_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_ami" "usa_latest_linux" {
  provider    = aws.USA
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_ami" "deu_latest_linux" {
  provider    = aws.DEU
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

