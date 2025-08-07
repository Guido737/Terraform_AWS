#------------------------------------------------------------
# Remote state: network module
#------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

#------------------------------------------------------------
# Latest Amazon Linux AMI
#------------------------------------------------------------
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
