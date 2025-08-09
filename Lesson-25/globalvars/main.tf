#--------------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made By Creator Eversor  
#--------------------------------------------------------------


provider "aws" {
  region = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#--------------------------------------------------------------

output "company_name" {
  value = "ANDESA Soft International"
}

output "owner" {
  value = "Creator Eversor"
}

output "tags" {
  value = {
    Project    = "Assembly-2025"
    CostCenter = "R&D"
    Country    = "Canada"
  }
}
