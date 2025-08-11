provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "new-staging/terraform.tfstate"
    region = "us-east-1"
  }
}
