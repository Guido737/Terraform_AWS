
provider "aws" {
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::639130796919:role/OrganizationAccountAccessRole"
  }
}

terraform {
  backend "s3" {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "dev/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

