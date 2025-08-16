include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//"
}

inputs = {
  bucket = "creator-eversor-terragrunt-dev"
  tags = {
    Owner       = "Creator Eversor"
    Environment = "dev"
  }
}
